//
//  ListViewModel.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 18/7/23.
//

import LocalAuthentication
import Foundation

class ListViewModel: ObservableObject {
    @Published var isUnlocked: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "To show your saved passwords."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self ] success, authenticationError in
                if success {
                    DispatchQueue.main.async {
                        self?.isUnlocked = true
                    }
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
}
