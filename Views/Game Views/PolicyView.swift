//
//  QTableView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 10/3/23.
//

import Foundation
import SwiftUI

struct PolicyView: View {
    @ObservedObject var environment: FrozenLakeEnvironment
    @ObservedObject var agent: FrozenLakeAgent
    @EnvironmentObject var settingStore: SettingStore
    
    let tileSize: CGFloat
    
    init(width: CGFloat, environment: FrozenLakeEnvironment, agent: FrozenLakeAgent) {
        tileSize = width / CGFloat(4)
        self.environment = environment
        self.agent = agent
    }
    
    func getArrow(action: Int) -> Image {
        switch(action) {
        case 0:
            return Image(systemName: "arrow.left")
        case 1:
            return Image(systemName: "arrow.down")
        case 2:
            return Image(systemName: "arrow.right")
        case 3:
            return Image(systemName: "arrow.up")
            
        default:
            return Image(uiImage: UIImage())
        }
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
    
                        ZStack {
                            Rectangle()
                                .fill(color)
                                .frame(width: tileSize, height: tileSize)
                                .overlay {
                                    if isTilePlayable(tile: tile) {
                                        getArrow(action: agent.getGreedyAction(state: environment.getState(for: (row, col))))
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                    }
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
