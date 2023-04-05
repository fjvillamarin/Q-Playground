//
//  Environment.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 7/3/23.
//

import Foundation
import SwiftUI

class FrozenLakeEnvironment: ObservableObject {
    @Published var agentPosition: (row: Int, col: Int) = (0, 0)
    
    let settingStore: SettingStore
    
    var regularMDP: [Int: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]]]
    var slipperyMDP: [Int: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]]]
    
    var regularQTable: [[Float]]
    var regularVTable: [Float]
    var regularVTableReference: [Float]
    
    var slipperyQTable: [[Float]]
    var slipperyVTable: [Float]
    var slipperyVTableReference: [Float]

    let nRows: Int = 4
    let nCols: Int = 4
    let nStates: Int = 16
    let nActions: Int = 4
    
    var isDone: Bool = false
    var lastGamma: Float
    var boardUpdated: Bool = false
    
    init(settingStore: SettingStore) {
        self.settingStore = settingStore
        
        self.regularMDP = [:]
        self.slipperyMDP = [:]
        
        self.regularQTable = []
        self.regularVTable = []
        self.regularVTableReference = []
        
        self.slipperyQTable = []
        self.slipperyVTable = []
        self.slipperyVTableReference = []
        
        self.lastGamma = -1
        
        self.regularMDP = createMDP(isSlippery: false)
        self.slipperyMDP = createMDP(isSlippery: true)
        
        self.updateTables()
    }
    
    func toggleTile(row: Int, col: Int) {
     
        switch(self.settingStore.board[row][col]) {
        case "F":
            self.settingStore.board[row][col] = "H"
        case "H":
            self.settingStore.board[row][col] = "G"
        case "G":
            self.settingStore.board[row][col] = "F"
        default:
            break
        }
        
        self.regularMDP = createMDP(isSlippery: false)
        self.slipperyMDP = createMDP(isSlippery: true)
        
        self.boardUpdated = true
        self.settingStore.boardVersion += 1
        
        self.updateTables()
    }
    
    func updateTables() {
        if settingStore.gamma == lastGamma && !boardUpdated {
            return
        }
        
        (_, regularVTableReference) = valueIteration(P: regularMDP, gamma: 1.0)
        (_, slipperyVTableReference) = valueIteration(P: slipperyMDP, gamma: 1.0)
        (regularQTable, regularVTable) = valueIteration(P: regularMDP, gamma: settingStore.gamma)
        (slipperyQTable, slipperyVTable) = valueIteration(P: slipperyMDP, gamma: settingStore.gamma)
        lastGamma = settingStore.gamma
        boardUpdated = false
    }
    
    private func createMDP(isSlippery: Bool) -> [Int: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]]] {
        var mdp: [Int: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]]] = [:]
        
        for state in 0..<nStates {
            let (row, col) = getPosition(for: state)
            
            if settingStore.board[row][col] == "H" || settingStore.board[row][col] == "G" {
                continue
            }
            
            var actions: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]] = [:]
            
            for action in 0..<4 {
                var transitions: [(prob: Float, state: Int, reward: Float, done: Bool)] = []
                let move = [(0, -1), (1, 0), (0, 1), (-1, 0)][action]
                
                let newRow = row + move.0
                let newCol = col + move.1
                
//                if newRow < 0 || newRow >= nRows || newCol < 0 || newCol >= nCols {
//                    // Agent hit a wall
//                    newRow = row
//                    newCol = col
//                }
                
                var nextStates = [(newRow, newCol)]
                
                if isSlippery {
                    // Add possible next states due to slipping
                    if action == 0 || action == 2 {
                        nextStates.append((row + 1, col))
                        nextStates.append((row - 1, col))
                    } else {
                        nextStates.append((row, col + 1))
                        nextStates.append((row, col - 1))
                    }
                }
                
                for nP in nextStates {
                    var nextPos = nP
                    
                    if nextPos.0 < 0 || nextPos.0 >= nRows || nextPos.1 < 0 || nextPos.1 >= nCols {
                        nextPos.0 = row
                        nextPos.1 = col
                    }
                    
                    let nextCell = settingStore.board[nextPos.0][nextPos.1]
                    let prob = isSlippery ? 1.0 / Float(nextStates.count) : 1.0
                    var reward: Float = 0.0
                    var done = false
                    
                    switch nextCell {
                    case "S":
                        reward = 0
                    case "F":
                        reward = 0
                    case "H":
                        reward = 0
                        done = true
                    case "G":
                        reward = 1
                        done = true
                    default:
                        fatalError("Invalid cell type: \(nextCell)")
                    }
                    
                    let nextState = getState(for: nextPos)
                    transitions.append((prob: prob, state: nextState, reward: reward, done: done))
                }
                
                actions[action] = transitions
            }
            mdp[state] = actions
        }
        
        return mdp
    }
    
    func getPosition(for state: Int) -> (row: Int, col: Int) {
        let row = state / nCols
        let col = state % nCols
        return (row, col)
    }
    
    func getState(for position: (row: Int, col: Int)) -> Int {
        return position.row * nCols + position.col
    }
    
    func reset() {
        agentPosition = (0, 0)
        isDone = false
        self.updateTables()
    }
    
    func resetBoard() {
        self.settingStore.board = [
            ["S", "F", "F", "F"],
            ["F", "H", "F", "H"],
            ["F", "F", "F", "H"],
            ["H", "F", "F", "G"]
        ]
        
        self.regularMDP = createMDP(isSlippery: false)
        self.slipperyMDP = createMDP(isSlippery: true)
        
        self.boardUpdated = true
    }
    
    func isWin(for state: Int) -> Bool {
        let (row, col) = getPosition(for: state)
        return settingStore.board[row][col] == "G"
    }
    
    func valueIteration(P: [Int: [Int: [(prob: Float, state: Int, reward: Float, done: Bool)]]], gamma: Float) -> (Q: [[Float]], V: [Float]) {
        var V = [Float](repeating: 0, count: nStates)
        var Q = [[Float]](repeating: [Float](repeating: 0, count: nActions), count: nStates)
        let theta: Float = 1e-10
        
        while true {
            Q = [[Float]](repeating: [Float](repeating: 0, count: nActions), count: nStates)
            // Compute Q
            for s in P.keys {
                for a in P[s]!.keys {
                    for (prob, next_state, reward, done) in P[s]![a]! {
                        //print(prob, next_state, reward, done)
                        //print(Q[s][a])
                        Q[s][a] += prob * (reward + gamma * V[next_state] * (done ? 0 : 1))
                        //print(Q[s][a])
                    }
                }
            }
            // Check for convergence
            let max_diff = zip(V, Q.map { row in row.max()! }).map { abs($0 - $1) }.max()!
            
            if max_diff < theta {
                break
            }
            
            V = Q.map { row in row.max()! }
        }
        
        return (Q, V)
    }
    
    func getMaximumProbability() -> Float {
        let nEpisodes: Int = 100
        var successCount: Float = 0
        var state: Int = 0
        updateTables()
        let mdp = settingStore.isSlippery ? slipperyMDP : regularMDP
        let Q = settingStore.isSlippery ? slipperyQTable : regularQTable
        
        for _ in 0..<nEpisodes {
            let action: Int = Q[state].firstIndex(of: Q[state].max()!)!
            
            var nextState: Int = state
            var reward: Float = 0.0
            var done: Bool = true
            
            let moveProbabilities = mdp[state]![action]!
            let rand = Float.random(in: 0..<1)
            var probabilitySum: Float = 0.0
            
            for (probability, nS, r, d) in moveProbabilities {
                probabilitySum += probability
                
                if rand <= probabilitySum {
                    nextState = nS
                    reward = r
                    done = d
                    break
                }
            }
            
            state = nextState
            
            if done {
                //self.gameState = environment.isWin(for: self.state) ? GameState.win : GameState.lose
                successCount += reward
                state = 0
            }
        }
        
        print(Q)
        print(successCount)
        return successCount / Float(nEpisodes)
    }
    
    func step(action: Int) -> (state: Int, reward: Float, done: Bool) {
        let state: Int = getState(for: agentPosition)
        
        if isDone {
            return (state: state, reward: 0.0, done: true)
        }
        
        var newState: Int = state
        var reward: Float = 0.0
        var done: Bool = true
        
        let mdp = settingStore.isSlippery ? slipperyMDP : regularMDP
        
        if let moveProbabilities = mdp[state]?[action] {
            let rand = Float.random(in: 0..<1)
            var probabilitySum: Float = 0.0
            
            for (probability, nS, r, d) in moveProbabilities {
                probabilitySum += probability
                
                if rand <= probabilitySum {
                    newState = nS
                    reward = r
                    done = d
                    break
                }
            }
        } else {
            fatalError("Invalid state or action: \(state), \(action)")
        }
        
        agentPosition = getPosition(for: newState)
        
        return (newState, reward, done)
    }
}
