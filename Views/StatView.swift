//
//  StatView.swift
//  Frozen Lake
//
//  Created by Fernando Villamarín Díaz on 11/3/23.
//

import Foundation
import SwiftUI
import Charts

struct StatView: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var statStore: StatStore
    @EnvironmentObject var modelStore: ModelStore
    
    @State private var selection = 0
    
    var body: some View {
        
        let offset = max(0, statStore.episodes - 50000)
        
        HStack {
            Chart {
                ForEach(Array(zip(Array(0..<statStore.successProbabilities.count), statStore.successProbabilities)), id:\.0) { data in
                    LineMark(
                        x: .value("Episode", offset + data.0 * 100),
                        y: .value("Sucess Rate", data.1 * 100)
                    )
                }
                RuleMark(y: .value("Optimal Policy Winrate", (settingStore.isSlippery ? modelStore.environment.slipperyVTableReference[0] : modelStore.environment.regularVTableReference[0]) * 100))
                    .annotation(position: .overlay, alignment: .bottomTrailing) { 
                        Text("Optimal Policy Success Rate")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .foregroundStyle(.red)
            }
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel()
                        .font(.subheadline)
                }
            }
            .chartXAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel()
                        .font(.subheadline)
                }
            }
            .chartXScale(domain: offset...max(statStore.episodes, 50000))
            .chartYScale(domain: 0...100)
            .chartXAxisLabel("Episodes")
            .chartYAxisLabel("Success Rate %")
            .padding(.horizontal, 50)
            .padding(.vertical, 20)
            
            Spacer()
            SidebarView()
        }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        
    }
}
