//
//  ModelStore.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 9/3/23.
//

import Foundation

class ModelStore: ObservableObject {
    @Published var environment: FrozenLakeEnvironment
    @Published var agent: FrozenLakeAgent
    
    init(settingStore: SettingStore, statStore: StatStore) {
        let environment = FrozenLakeEnvironment(settingStore: settingStore)
        
        self.environment = environment
        self.agent = FrozenLakeAgent(environment: environment, settingStore: settingStore, statStore: statStore)
    }
}
