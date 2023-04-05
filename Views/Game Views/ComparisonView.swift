//
//  ComparisonView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 10/3/23.
//

import Foundation
import SwiftUI

struct ComparisonView: View {
    @ObservedObject var environment: FrozenLakeEnvironment
    @ObservedObject var agent: FrozenLakeAgent
    
    @EnvironmentObject var settingStore: SettingStore
    
    let tileSize: CGFloat
    
    init(width: CGFloat, environment: FrozenLakeEnvironment, agent: FrozenLakeAgent) {
        tileSize = width / CGFloat(4)
        self.environment = environment
        self.agent = agent
    }
    
    func isTilePlayable(tile: String) -> Bool {
        switch tile {
        case "S":
            return true
        case "F":
            return true
        case "H":
            return false
        case "G":
            return false
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<settingStore.board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<settingStore.board[row].count, id: \.self) { col in
                        let tile = settingStore.board[row][col]
                        let color = tileColor(tile)
                        let state = environment.getState(for: (row, col))
                        let values = agent.Q[state]
                        let action = agent.getGreedyAction(state: environment.getState(for: (row, col)))
                        let trueQ = settingStore.isSlippery ? environment.slipperyQTable : environment.regularQTable
                        let trueValues = trueQ[state]
                        
                        ZStack {
                            Rectangle()
                                .fill(color)
                                .frame(width: tileSize, height: tileSize)
                            
                            if isTilePlayable(tile: tile) {
                                // Up arrow
                                HStack {
                                    Text(String(format: "%.3f", values[3]))
                                        .font(.footnote)
                                    Image(systemName: "arrow.up")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(action == 3 ? .red : .white)
                                    Text(String(format: "%.3f", trueValues[3]))
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .offset(y: -tileSize / 3)
                                .opacity(1)

                                // Down arrow
                                HStack {
                                    Text(String(format: "%.3f", values[1]))
                                        .font(.footnote)
                                    Image(systemName: "arrow.down")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(action == 1 ? .red : .white)
                                    Text(String(format: "%.3f", trueValues[1]))
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .offset(y: tileSize / 3)
                                .opacity(1)

                                // Left arrow
                                VStack {
                                    Text(String(format: "%.3f", values[0]))
                                        .font(.footnote)
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(action == 0 ? .red : .white)
                                    Text(String(format: "%.3f", trueValues[0]))
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .offset(x: -tileSize / 3)
                                .opacity(1)

                                // Right arrow
                                VStack {
                                    Text(String(format: "%.3f", values[2]))
                                        .font(.footnote)
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(action == 2 ? .red : .white)
                                    Text(String(format: "%.3f", trueValues[2]))
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .offset(x: tileSize / 3)
                                .opacity(1)
                            }
                            
                            if row == environment.agentPosition.row && col == environment.agentPosition.col {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: tileSize / 4, height: tileSize / 4)
                            }
                        }
                        .onTapGesture {
                            self.environment.toggleTile(row: row, col: col)
                        }
                    }
                }
            }
        }
    }
    
    func tileColor(_ tile: String) -> Color {
        switch tile {
        case "S":
            return .green
        case "F":
            return .blue
        case "H":
            return .gray
        case "G":
            return .yellow
        default:
            return .white
        }
    }
}
