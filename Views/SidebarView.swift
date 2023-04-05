//
//  SidebarView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 8/3/23.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var statStore: StatStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Gamma section
            VStack(alignment: .leading) {
                Text("Gamma")
                    .font(.headline)
                Slider(value: $settingStore.gamma, in: 0.0...1.0, step: 0.01)
                    .onChange(of: settingStore.gamma, perform: { value in
                        self.modelStore.environment.updateTables()
                    })
                Text("Gamma: \(settingStore.gamma, specifier: "%.2f")")
            }
            .padding(.top, 10)
            
            // Alpha section
            VStack(alignment: .leading) {
                Text("Alpha")
                    .font(.headline)
                Slider(value: $settingStore.alpha, in: 0.0...1.0, step: 0.01)
                Text("Alpha: \(settingStore.alpha, specifier: "%.2f")")
            }
            .padding(.top, 10)
            
            // Epsilon section
            VStack(alignment: .leading) {
                Text("Epsilon")
                    .font(.headline)
                Slider(value: $settingStore.epsilon, in: 0.0...1.0, step: 0.01)
                Text("Epsilon: \(settingStore.epsilon, specifier: "%.2f")")
            }
            .padding(.top, 10)
            
            // Buttons section
            VStack {
                Toggle("Greedy", isOn: $settingStore.isGreedy)
                    .font(.headline)
                    .padding()
                Toggle("Slippery", isOn: $settingStore.isSlippery)
                    .font(.headline)
                    .padding()
            }
            .padding(.top, 10)
            
            HStack(spacing: 20) {
                
                CustomButton(normalImage: Image("Reset_button"), pressedImage: Image("Reset_button_pressed")) {
                    modelStore.agent.pause()
                    modelStore.agent.reset()
                    modelStore.environment.resetBoard()
                    statStore.reset()
                }
                
                CustomButton(normalImage: Image("Step_button"), pressedImage: Image("Step_button_pressed")) {
                    modelStore.agent.move()
                }
                if settingStore.gameState == GameState.paused {
                    CustomButton(normalImage: Image("Play_button"), pressedImage: Image("Play_button_pressed")) {
                        modelStore.agent.toggleAutoPlay()
                    }
                } else {
                    CustomButton(normalImage: Image("Pause_button"), pressedImage: Image("Pause_button_pressed")) {
                        modelStore.agent.toggleAutoPlay()
                    }
                }
                
                CustomButton(normalImage: Image("Forward_button"), pressedImage: Image("Forward_button_pressed")) {
                    modelStore.agent.incrementSpeed()
                    modelStore.environment.reset()
                }
            }
            .font(.system(size: 25))
            .foregroundColor(.black)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Add margins of 20 points to all sides
        .frame(width: 300)
        .background(Color.gray.opacity(0.1)) // Add a background color to the sidebar
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .blur(radius: 10)
//        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
