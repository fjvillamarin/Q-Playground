//
//  GameView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 8/3/23.
//

import Foundation
import SwiftUI

struct GameView: View {
    @EnvironmentObject var settingsStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    
    @State private var selection = 0
    
    var body: some View {
        
        HStack {
            EnvironmentView(agent: modelStore.agent)
            SidebarView()
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
    }
        
}
