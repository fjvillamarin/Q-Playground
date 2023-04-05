import SwiftUI

struct CustomToggle: View {
    let pressedImage: String
    let normalImage: String
    @EnvironmentObject var settingStore: SettingStore
    let targetViewMode: ViewMode
    
    var body: some View {
        ZStack {
            if settingStore.viewMode == targetViewMode {
                Image(pressedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(normalImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onTapGesture {
            settingStore.viewMode = targetViewMode
        }
        .frame(width: 70, height: 60)
    }
}
