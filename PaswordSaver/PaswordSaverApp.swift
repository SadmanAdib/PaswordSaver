//
//  PaswordSaverApp.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 17/7/23.
//

import SwiftUI

@main
struct PaswordSaverApp: App {
    @StateObject private var generatorViewModel = GeneratorViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(generatorViewModel)
        }
    }
}
