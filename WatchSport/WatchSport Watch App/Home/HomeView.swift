//
//  HomeView.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
            }
        }
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    HomeView()
}
