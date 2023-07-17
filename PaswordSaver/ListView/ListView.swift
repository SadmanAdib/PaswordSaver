//
//  ListView.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 17/7/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var generatorViewModel: GeneratorViewModel
    @StateObject private var listViewModel = ListViewModel()
    var body: some View {
        NavigationView {
            if listViewModel.isUnlocked {
                List {
                    if !generatorViewModel.passwords.isEmpty {
                        ForEach(generatorViewModel.passwords, id: \.id) { password in
                            Section("\(password.title)") {
                                HStack {
                                    Text("\(password.password)")
                                        .textSelection(.enabled)
                                        
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(password.strengthColor)
                                }
                            }
                            .swipeActions {
                                Button("delete") {
                                    generatorViewModel.deleteItemFromKeychain(identifier: password.id.uuidString)
                                }
                                .tint(.red)
                            }
                        }
                        .navigationTitle("Passwords")
                    } else {
                        Text("No Passwords in the list yet 😕")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                    }
                }
                .onAppear {
                    generatorViewModel.passwords = generatorViewModel.retrieveAllItemsFromKeychain() ?? []
                }
            } else {
                Text("You Are Not Authorised Yet!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            listViewModel.isUnlocked = false
            listViewModel.authenticate()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(GeneratorViewModel())
    }
}
