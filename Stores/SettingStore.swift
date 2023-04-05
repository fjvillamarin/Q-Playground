//
//  EnvironmentHandler.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 8/3/23.
//

import Foundation
import SwiftUI

enum ViewMode {
    case gameBoard
    case policy
    case qTable
    case comparison
}

enum GameState {
    case running
    case background
    case paused
    case lose
    case win
}

class SettingStore: ObservableObject {
    @Published var board: [[String]] = [
        ["S", "F", "F", "F"],
        ["F", "H", "F", "H"],
        ["F", "F", "F", "H"],
        ["H", "F", "F", "G"]
    ]
    
    var boardVersion: Int = 0
    
    @Published var gamma: Float = 0.9
    @Published var epsilon: Float = 0.5
    @Published var alpha: Float = 0.5
    
    @Published var isSlippery: Bool = true
    
    @Published var viewMode: ViewMode = ViewMode.gameBoard
    @Published var gameState: GameState = GameState.paused
    @Published var isGreedy: Bool = false
    
    let nStates: Int = 16
    let nActions: Int = 4
}
