import SwiftUI

@main
struct QLearningPlayground: App {
    
    @StateObject var settingStore: SettingStore
    @StateObject var modelStore: ModelStore
    @StateObject var statStore: StatStore
    
    init() {
        let settingS = SettingStore()
        let statS = StatStore()
        self._settingStore = StateObject(wrappedValue: settingS)
        self._modelStore = StateObject(wrappedValue: ModelStore(settingStore: settingS, statStore: statS))
        self._statStore = StateObject(wrappedValue: statS)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
                .preferredColorScheme(.light)
                .environmentObject(settingStore)
                .environmentObject(modelStore)
                .environmentObject(statStore)
        }
    }
}
