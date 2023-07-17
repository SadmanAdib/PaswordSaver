//
//  ContentView.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 17/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GeneratorView()
                .tabItem {
                    Label("Generator", systemImage: "pencil.circle.fill")
                }
            
            ListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
