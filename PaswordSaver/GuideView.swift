//
//  GuideView.swift
//  PaswordSaver
//
//  Created by Sadman Adib on 18/7/23.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Spacer()
                    Text("Very Weak")
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Spacer()
                    Text("Weak")
                }
                .foregroundColor(.green)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Spacer()
                    Text("Strong")
                }
                .foregroundColor(.yellow)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Spacer()
                    Text("Very Strong")
                }
                .foregroundColor(.red)
            }
            .font(.title)
            .padding(.horizontal, 50)
            .navigationTitle("Color Indications")
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
