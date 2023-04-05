//
//  ContentView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 7/3/23.
//

import SwiftUI
import UIKit

struct PlaygroundView: View {
    @State private var selection = 0
    
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var statStore: StatStore
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ZStack {
                if selection == 0 {
                    VStack {
                        Spacer()
                        GameView()
                        Spacer()
                    }
//                    .background(Color(red: 199/256, green: 236/256, blue: 238/256))
                }
                if selection == 1 {
                    StatView()
                }
                if selection == 2 {
                    WikiView()
                        .onAppear(perform: {
                            modelStore.agent.pause()
                        })
                }
            }
//            .padding(.bottom, -8)
//            
//            Divider()
//                .frame(maxHeight: 0)
            
            
            HStack {
                Spacer()
                Button(action: { selection = 0 }) {
                    VStack {
                        Image(systemName: "gamecontroller")
                        Text("Game")
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 20)
                }
                .foregroundColor(selection == 0 ? Color.blue : Color.primary)
                Spacer()
                Button(action: { selection = 1 }) {
                    VStack {
                        Image(systemName: "chart.bar")
                        Text("Stats")
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 20)
                }
                .foregroundColor(selection == 1 ? Color.blue : Color.primary)
                Spacer()
                Button(action: { selection = 2 }) {
                    VStack {
                        Image(systemName: "info.circle")
                        Text("Wiki")
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 20)
                }
                .foregroundColor(selection == 2 ? Color.blue : Color.primary)
                Spacer()
            }
            .background(
                Color(.systemBackground)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
                )
        }
//        .background(.red)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
