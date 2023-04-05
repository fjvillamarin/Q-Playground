//
//  Agent.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 7/3/23.
//

import Foundation
import SwiftUI

class FrozenLakeAgent: ObservableObject {
    var environment: FrozenLakeEnvironment
    var settingStore: SettingStore
    var statStore: StatStore
    
    @Published var Q: [[Float]] // a table to store Q-values for each state-action pairs
    
    @Published var speed: Int = 0
    private var state: Int = 0
    private var done: Bool = false
    
    private var resultsWindow: [Float] = []
    private var windowSize: Int = 100
    
    private var timer: Timer?
    
    init(environment: FrozenLakeEnvironment, settingStore: SettingStore, statStore: StatStore) {
        self.environment = environment
        self.Q = Array(repeating: Array(repeating: 0, count: settingStore.nActions), count: settingStore.nStates)
        self.settingStore = settingStore
        self.statStore = statStore
    }
    
    func getGreedyAction(state: Int) -> Int {
        return Q[state].firstIndex(of: Q[state].max()!)!
    }
    
    func getVTable() -> [Float] {
        return Q.map { row in row.max()! }
    }
    
    func selectAction(state: Int) -> Int {
        // Epsilon-greedy action selection
        if Float.random(in: 0..<1) < settingStore.epsilon && !settingStore.isGreedy{
            //print(settingStore.epsilon)
            return Int.random(in: 0..<settingStore.nActions)
        } else {
            return getGreedyAction(state: state)
        }
    }
    
    func updatePolicy(state: Int, action: Int, reward: Float, nextState: Int) {
        // Q-Learning update rule
        let tdTarget = reward + settingStore.gamma * Q[nextState].max()!
        let tdError = tdTarget - Q[state][action]
        Q[state][action] += settingStore.alpha * tdError
    }
    
    func move() {
        if done {
            //self.gameState = environment.isWin(for: self.state) ? GameState.win : GameState.lose
            environment.reset()
            statStore.episodes += 1
            state = 0
        }
        
        let action = selectAction(state: state)
        let (nextState, reward, done) = environment.step(action: action)
        
        updatePolicy(state: state, action: action, reward: reward, nextState: nextState)
        
        //print(state, action, nextState, done)
        
        self.state = nextState
        self.done = done
        
        if done {
            addResult(result: reward)
        }
    }
    
    func incrementSpeed() {
        speed = (speed + 1) % 4
        pause()
        play()
    }
    
    func getTimeInterval() -> TimeInterval {
        switch(speed) {
        case 0:
            return 0.5
        case 1:
            return 0.1
        case 2:
            return 0.0001
        case 3:
            return 0
            
        default:
            return 0.5
        }
    }
    
    func reset() {
        self.settingStore.gameState = GameState.paused
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {timer in
            self.Q = Array(repeating: Array(repeating: 0, count: self.settingStore.nActions), count: self.settingStore.nStates)
            self.environment.reset()
            self.statStore.episodes = 0
            self.speed = 0
            self.resultsWindow = []
        }
    }
    
    func addResult(result: Float) {
        resultsWindow.append(result)
        
        if resultsWindow.count == windowSize {
            let successProbability: Float = resultsWindow.reduce(0, +) / Float(windowSize)
            
            DispatchQueue.main.async {
                self.statStore.addProbability(probability: successProbability)
            }
            
            resultsWindow.removeAll()
        }
    }
    
    func trainInBackground() {
        DispatchQueue.global(qos: .background).async {
            var Q = self.Q
            var episodes = self.statStore.episodes
            var state = self.state
            
            var environment = FrozenLakeEnvironment(settingStore: self.settingStore)
            var boardVersion = self.settingStore.boardVersion
            
            while self.settingStore.gameState == GameState.background {
                var action: Int = 0
                
                if Float.random(in: 0..<1) < self.settingStore.epsilon && !self.settingStore.isGreedy{
                    //print(settingStore.epsilon)
                    action = Int.random(in: 0..<self.settingStore.nActions)
                } else {
                    action = Q[state].firstIndex(of: Q[state].max()!)!
                }
                let (nextState, reward, done) = environment.step(action: action)
                
                let tdTarget = reward + self.settingStore.gamma * Q[nextState].max()!
                let tdError = tdTarget - Q[state][action]
                Q[state][action] += self.settingStore.alpha * tdError
                
                //print(state, action, nextState, done)
                
                state = nextState
                
                if done {
                    //self.gameState = environment.isWin(for: self.state) ? GameState.win : GameState.lose
                    environment.reset()
                    episodes += 1
                    state = 0
                    self.addResult(result: reward)
                    
                    if episodes % 100 == 0 {
                        DispatchQueue.main.async {
                            self.Q = Q
                            self.statStore.episodes = episodes
                        }
                        
                        if boardVersion != self.settingStore.boardVersion {
                            environment = FrozenLakeEnvironment(settingStore: self.settingStore)
                            boardVersion = self.settingStore.boardVersion
                        }
                    }
                }
                
                
            }
            
            DispatchQueue.main.async {
                self.Q = Q
                self.statStore.episodes = episodes
            }
        }
    }
    
    func play() {
        if speed >= 3 {
            settingStore.gameState = GameState.background
            trainInBackground()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: getTimeInterval(), repeats: true) { timer in
                self.move()
            }
            settingStore.gameState = GameState.running
        }
    }
    
    func pause() {
        if settingStore.gameState == GameState.background {
            settingStore.gameState = GameState.paused
        } else {
            timer?.invalidate()
            settingStore.gameState = GameState.paused
        }
    }
    
    func toggleAutoPlay() {
        if settingStore.gameState == GameState.paused {
            play()
        } else {
            pause()
            settingStore.gameState = GameState.paused
        }
    }
}
