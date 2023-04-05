//
//  EnvironmentView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 8/3/23.
//

import Foundation
import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    @ObservedObject var agent: FrozenLakeAgent
    
    func getBoardWidth(_ geometry: GeometryProxy) -> CGFloat {
        return min(geometry.size.width, geometry.size.height) / 1.5
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .center) {
                Spacer()
                VStack (alignment: .center, spacing: 0) {
                    Spacer()
                    // Top Bar
                    HStack {
                        // Train Settings
                        Text("Rounds: \(statStore.episodes)")
                            .font(.headline)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 0)
                        
                        Spacer()
                        
                        // Step buttons
                        HStack(spacing: 20) {
                            CustomToggle(
                                pressedImage: "L_button_pressed",
                                normalImage: "L_button",
                                targetViewMode: .gameBoard
                            )
                            
                            CustomToggle(
                                pressedImage: "PI_button_pressed",
                                normalImage: "PI_button",
                                targetViewMode: .policy
                            )
                            
                            CustomToggle(
                                pressedImage: "Q_button_pressed",
                                normalImage: "Q_button",
                                targetViewMode: .qTable
                            )
                            
                            CustomToggle(
                                pressedImage: "Q*_button_pressed",
                                normalImage: "Q*_button",
                                targetViewMode: .comparison
                            )
                            
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.black)
//                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
//                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                    }
                    .padding(.bottom, 10)
                    .frame(width: getBoardWidth(geometry))
                    
                    switch(settingStore.viewMode) {
                    case .gameBoard: BoardView(width: getBoardWidth(geometry), environment: modelStore.environment, agent: modelStore.agent)
                    case .qTable: QTableView(width: getBoardWidth(geometry), environment: modelStore.environment, agent: modelStore.agent)
                    case .policy: PolicyView(width: getBoardWidth(geometry), environment: modelStore.environment, agent: modelStore.agent)
                    case .comparison: ComparisonView(width: getBoardWidth(geometry), environment: modelStore.environment, agent: modelStore.agent)
                    }
                    
                    Spacer()
                    
                    // Bottom Bar
                    //                HStack(spacing: 20) {
                    //                    Button(action: {
                    //                        agent.reset()
                    //                    }) {
                    //                        Image(systemName: "arrow.clockwise")
                    //                    }
                    //                    Button(action: {
                    //                        agent.move()
                    //                    }) {
                    //                        Image(systemName: "arrow.counterclockwise")
                    //                    }
                    //                    Button(action: {
                    //                        agent.toggleAutoPlay()
                    //                    }) {
                    //                        Image(systemName: "arrow.up")
                    //                    }
                    //                    Button(action: {
                    //                        agent.incrementSpeed()
                    //                    }) {
                    //                        Image(systemName: "arrow.clockwise")
                    //                    }
                    //                }
                    //                .font(.system(size: 20))
                    //                .foregroundColor(.black)
                    //                .frame(height: 40)
                    //                .frame(maxWidth: .infinity)
                    //                .background(Color.white.opacity(0.8))
                    //                .cornerRadius(20)
                    
                }
                Spacer()
            }
        }
    }
}
