//
//  BoardView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 9/3/23.
//

import Foundation
import SwiftUI

struct BoardView: View {
    @ObservedObject var environment: FrozenLakeEnvironment
    @ObservedObject var agent: FrozenLakeAgent
    @EnvironmentObject var settingStore: SettingStore
    
    let tileSize: CGFloat
    
//    private var spriteBoard: [[String]] = [
//        ["snow_tl", "snow_t", "snow_trtl", "snow_t"],
//        ["snow_l", "hole_4", "snow_rl", "hole"],
//        ["snow_tbl", "snow_btr", "snow_lbr", "hole"],
//        ["hole", "snow_r", "snow_bl", "snow_b"]
//    ]
    
//    private var spriteBoard: [[String]] = [
//        ["snow", "snow", "snow", "snow"],
//        ["snow", "hole", "snow", "hole"],
//        ["snow", "snow", "snow", "hole"],
//        ["hole", "snow", "snow", "snow"]
//    ]
    
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
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<settingStore.board.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<settingStore.board[row].count, id: \.self) { col in
                            let tile = settingStore.board[row][col]
                            
                            ZStack {
                                Image(tileSprite(row: row, col: col))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: tileSize, height: tileSize)
                                
                                if tile == "G" {
                                    Image("apple")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: tileSize / 2.8, height: tileSize / 2.9)
                                }
                                
                                if row == environment.agentPosition.row && col == environment.agentPosition.col {
                                    AnimatedSprite()
                                        .frame(width: tileSize / 2, height: tileSize / 2)
                                }
                            }
                            .onTapGesture {
                                self.environment.toggleTile(row: row, col: col)
                            }
                        }
                    }
                }
            }
            .opacity(settingStore.gameState == GameState.background ? 0.5 : 1.0)
            
            if settingStore.gameState == GameState.background {
                Text("The simulation is running too fast to update the board 😅")
                    .font(.headline)
            }
        }
    }
    
    func tileSprite(row: Int, col: Int) -> String {
        let tile = settingStore.board[row][col]
        
        switch (tile) {
        case "F":
            return "snow"
        case "H":
            return "hole"
        default:
            return "snow"
        }
    }
}
