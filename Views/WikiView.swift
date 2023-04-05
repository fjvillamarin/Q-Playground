import SwiftUI

struct WikiPage: Identifiable {
    let id = UUID()
    let title: String
    let content: AnyView
}

struct WikiView: View {
    let pages = [
        WikiPage(title: "Overview 📝", content: AnyView(WelcomeView2(isWelcome: false))),
        WikiPage(title: "Change View Modes 🔄👁️", content: AnyView(WelcomeView3(isWelcome: false))),
        WikiPage(title: "Q-Learning Parameters 🎮🧠", content: AnyView(WelcomeView4(isWelcome: false))),
        WikiPage(title: "Take Control 🕹️", content: AnyView(WelcomeView5(isWelcome: false))),
        WikiPage(title: "Dive into the Stats 📊", content: AnyView(WelcomeView6(isWelcome: false))),
        WikiPage(title: "Credits 🌟", content: AnyView(WelcomeView8())),
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pages) { page in
                    NavigationLink(destination: WikiPageDetailView(page: page)) {
                        Text(page.title)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Sidebar")
            .frame(minWidth: 300)
            
            Text("Select a page")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct WikiPageDetailView: View {
    let page: WikiPage
    
    var body: some View {
        page.content
    }
}

struct WikiView_Previews: PreviewProvider {
    static var previews: some View {
        WikiView()
    }
}
