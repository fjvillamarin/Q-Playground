//
//  StatisticStore.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 10/3/23.
//

import Foundation

class StatStore: ObservableObject {
    @Published var successProbabilities: [Float] = [0]
    var probArraySize: Int = 500
    @Published var episodes: Int = 0
    
    func reset() {
        successProbabilities = [0]
        episodes = 0
    }
    
    func addProbability(probability: Float) {
        successProbabilities.append(probability)
        
        if successProbabilities.count > probArraySize {
            successProbabilities.removeFirst() // remove the oldest item from the front of the array
        }
    }
}
