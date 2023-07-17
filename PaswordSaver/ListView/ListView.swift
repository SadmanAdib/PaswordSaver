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
    
    @Environment(\.scenePhase) var scenePhase
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
                        .onChange(of: scenePhase) { newPhase in
                            switch newPhase {
                            case .inactive, .background:
                                listViewModel.isUnlocked = false
                            default:
                                break
                            }
                        }
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
                VStack {
                    Text("Please Authenticate Yourself First!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Button {
                        listViewModel.authenticate()
                    } label: {
                        Text("Authenticate")
                            .foregroundColor(.white)
                            .padding(10)
                            .background {
                                Color.green
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
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
