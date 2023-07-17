//
//  GeneratorView.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 17/7/23.
//

import SwiftUI

struct GeneratorView: View {
    @EnvironmentObject var generatorViewModel: GeneratorViewModel
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("eg: Twitter", text: $generatorViewModel.title)
                }
                if !generatorViewModel.showGenerator {
                    Section("Manually Type Password") {
                        TextField("Type Password or use generator below", text: $generatorViewModel.manualPasswordString)
                        
                        Button {
                            generatorViewModel.createPassword()
                            generatorViewModel.addToPasswords()
                            generatorViewModel.manualPasswordString = ""
                        } label: {
                            HStack {
                                Spacer()
                                Text("Add To List")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        generatorViewModel.manualPasswordString == "" ? Color.gray : Color.blue
                                    }
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                Spacer()
                            }
                        }
                        .disabled(generatorViewModel.manualPasswordString == "")
                }
                    Button {
                        withAnimation {
                            generatorViewModel.showGenerator = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Use Generator")
                                .foregroundColor(.white)
                                .padding(10)
                                .background {
                                    Color.green
                                }
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            Spacer()
                        }
                    }
                    
                }
                
                if generatorViewModel.showGenerator {
                    Section("Options") {
                        Toggle("Symbols", isOn: $generatorViewModel.containsSymbols)
                        Toggle("Uppercase", isOn: $generatorViewModel.containsUppercase)
                        Stepper("Character count: \(generatorViewModel.length)", value: $generatorViewModel.length, in: 6...18)
                        HStack {
                            Spacer()
                            Button("Generate password", action: generatorViewModel.createPassword)
                            Spacer()
                        }
                    }
                    
                    Section("Generated Password") {
                        HStack {
                            Text("\(generatorViewModel.currentPassword.password)")
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .textSelection(.enabled)
                            Spacer()
                            Button {
                                generatorViewModel.addToPasswords()
                            } label: {
                                Text("Add To List")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        Color.blue
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(generatorViewModel.currentPassword.strengthColor)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            generatorViewModel.showGenerator = false
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Use Manual Password")
                                .foregroundColor(.white)
                                .padding(10)
                                .background {
                                    Color.green
                                }
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Password Generator")
            .sheet(isPresented: $generatorViewModel.showGuideView, content: {
                GuideView()
            })
            .alert("Password Added Successfully!", isPresented: $generatorViewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        generatorViewModel.showGuideView = true
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }

                }
            }
        }
    }
}

struct GeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
            .environmentObject(GeneratorViewModel())
    }
}
