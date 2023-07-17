//
//  GeneratorViewModel.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 17/7/23.
//

import SwiftUI
import Security

class GeneratorViewModel: ObservableObject {
    @Published var passwords: [Password] = []
    @Published var currentPassword: Password = Password(password: "", title: "", containsSymbols: false, containsUppercase: false)
    @Published var title = ""
    @Published var containsSymbols = true
    @Published var containsUppercase = true
    @Published var length = 10
    
    @Published var manualPasswordString: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var showGenerator: Bool = false {
        didSet {
            if showGenerator {
                createPassword()
            } else {
                containsSymbols = true
                containsUppercase = true
            }
        }
    }
    
    init() {
        createPassword()
    }
    
    func addToPasswords() {
        passwords.append(currentPassword)
        saveItemToKeychain()
        title = ""
    }
    
    func createPassword() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var base = alphabet + "123456790"
        var newPassword = ""
        
        if showGenerator {
            newPassword = ""
        } else {
            newPassword = manualPasswordString
        }
        
        var title = title
        
        if containsSymbols {
            base += "!£$%&/()=?^;:_*,.-"
        }
        if containsUppercase {
            base += alphabet.uppercased()
        }
        
        if showGenerator {
            for _ in 0..<length {
                let randomChar = base.randomElement()!
                newPassword += String(randomChar)
            }
        }
        
        if title.isEmpty {
            title = "No Title"
        }
        
        let password = Password(password: newPassword, title: title, containsSymbols: containsSymbols, containsUppercase: containsUppercase)
        
        withAnimation {
            currentPassword = password
        }
    }

    func saveItemToKeychain() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(currentPassword) else {
            print("Error encoding the custom model to Data")
            return
        }
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: currentPassword.id.uuidString,
            kSecValueData as String: data,
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Item saved successfully in the Keychain")
            showAlert = true
        } else if let error = SecCopyErrorMessageString(status, nil) {
            let errorMessage = String(describing: error)
            print("Error saving item to the Keychain: \(errorMessage)")
        } else {
            print("Something went wrong trying to save the Item in the Keychain")
        }
    }
    
    func retrieveAllItemsFromKeychain() -> [Password]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
            let items = result as? [[String: Any]] else {
            return nil
        }

        var passwords: [Password] = []

        for item in items {
            guard let data = item[kSecValueData as String] as? Data,
                let model = try? JSONDecoder().decode(Password.self, from: data) else {
                    continue
            }
            passwords.append(model)
        }

        return passwords
    }
    
    func deleteItemFromKeychain(identifier: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Item deleted successfully from the Keychain")
        } else {
            if let error = SecCopyErrorMessageString(status, nil) {
                let errorMessage = String(describing: error)
                print("Error deleting item from the Keychain: \(errorMessage)")
            } else {
                print("Failed to delete item from the Keychain")
            }
        }
        
        withAnimation {
            passwords = retrieveAllItemsFromKeychain() ?? []
        }
    }
}
