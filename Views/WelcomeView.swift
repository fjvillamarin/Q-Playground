import SwiftUI

struct WelcomeView1: View {
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 40){
                Spacer()
                Text("Welcome to the Q-Learning Playground!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                
                Text("developed by Fernando Villamarin")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                AnimatedSprite()
                    .frame(width: 100, height: 100)
                
                Text("Here, you'll have a fun time teaching a Q-Learning agent to find its way through a maze-like environment called the Frozen Lake.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("Q-Learning is a type of Reinforcement Learning (RL), which is a way for computers to learn by trial and error. In this app, the agent will explore the Frozen Lake, learning from its experiences and eventually figuring out the best path to reach its goal.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Text("Sit back and enjoy as your agent becomes an icy maze-master!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                if isWelcome {
                    HStack {
                        NavigationLink(destination: WelcomeView2()) {
                            Text("Check the Guide 🤓")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                        
                        NavigationLink(destination: PlaygroundView()) {
                            Text("Enter the Playground 😎")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 100)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView2: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .center, spacing: 40){
                    Spacer()
                    
                    Text("Overview 📝")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("Guide the fox across the icy lake, avoiding holes and aiming for the delicious apple!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text("Each game round ends when the fox falls into a hole or reaches the apple.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Text("Completing the journey and reaching an apple brings a happy reward for our smart little fox!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    BoardView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                    
                    Text("Click on the tiles to customize the layout, making the journey easier or more challenging for the fox!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    if isWelcome {
                        NavigationLink(destination: WelcomeView3()) {
                            Text("Next")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 100)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView3: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .center, spacing: 40){
                    Spacer()
                    
                    Text("Change View Modes 🔄👁️")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("Peek into the agent's mind by switching between various view modes with the provided toggles:")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 20) {
                        CustomToggle(
                            pressedImage: "L_button_pressed",
                            normalImage: "L_button",
                            targetViewMode: .gameBoard
                        )
                        
                        CustomToggle(
                            pressedImage: "PI_button_pressed",
                            normalImage: "PI_button",
                            targetViewMode: .policy
                        )
                        
                        CustomToggle(
                            pressedImage: "Q_button_pressed",
                            normalImage: "Q_button",
                            targetViewMode: .qTable
                        )
                        
                        CustomToggle(
                            pressedImage: "Q*_button_pressed",
                            normalImage: "Q*_button",
                            targetViewMode: .comparison
                        )
                        
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    //                        .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    //                        .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    
                    switch(settingStore.viewMode) {
                    case .gameBoard: 
                        VStack {
                            Text("Frozen Lake Mode")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            Text("Observe the icy labyrinth where the agent learns to find its way.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            BoardView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                        }
                    case .qTable: 
                        VStack {
                            Text("Q Table Mode")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            Text("Explore the agent's \"knowledge bank\" as it assigns values to each state-action pair, reflecting its preferences in different situations.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            QTableView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                        }
                    case .policy: 
                        VStack {
                            Text("Policy Mode")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            Text("Uncover the agent's current strategy, revealing the action it believes is best in each state.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            PolicyView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                        }
                    case .comparison: 
                        VStack {
                            Text("Q Table Comparison Mode")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            Text("Compare the agent's learning progress by checking its current Q values (left/top) against the optimal Q values (right/bottom) for each action, showcasing how well the agent is doing in relation to the best possible strategy.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            ComparisonView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                        }
                    }
                    
                    Text("Immerse yourself in these modes and enjoy witnessing the fascinating process of the agent's learning journey in the Q-Learning playground!")
                        .font(.title)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                    
                    if isWelcome {
                        NavigationLink(destination: WelcomeView4()) {
                            Text("Next")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                    
                    Spacer()
                }
//                .frame(width: .infinity, height: .infinity, alignment: .center)
                .padding(.horizontal, 100)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView4: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .center, spacing: 40){
                    Spacer()
                    
                    Group {
                        Text("Play with Q-Learning Parameters 🎮🧠")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("Customize the agent's behavior using the sidebar controls to influence the learning process:")
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }
                    
                    Group {
                        Text("Adjust the gamma to change the agent's focus on immediate vs. future rewards. Higher values prioritize long-term gains, while lower values emphasize short-term rewards.")
                            .font(.title2)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading) {
                            Text("Gamma")
                                .font(.headline)
                            Slider(value: $settingStore.gamma, in: 0.0...1.0, step: 0.01)
                                .onChange(of: settingStore.gamma, perform: { value in
                                    self.modelStore.environment.updateTables()
                                })
                            Text("Gamma: \(settingStore.gamma, specifier: "%.2f")")
                        }
                        .frame(width: 300)
                        .padding(.top, 10)
                        
                        Text("Use the alpha to control the agent's learning rate, affecting how new experiences influence its knowledge. Higher values lead to faster adaptation, while lower values result in more gradual learning.")
                            .font(.title2)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                        
                        // Alpha section
                        VStack(alignment: .leading) {
                            Text("Alpha")
                                .font(.headline)
                            Slider(value: $settingStore.alpha, in: 0.0...1.0, step: 0.01)
                            Text("Alpha: \(settingStore.alpha, specifier: "%.2f")")
                        }
                        .frame(width: 300)
                        .padding(.top, 10)
                        
                        Text("Balance exploration (trying new actions) and exploitation (using known information) with the epsilon value. Higher values encourage exploration, while lower values promote sticking with familiar actions.")
                            .font(.title2)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                        
                        
                        // Epsilon section
                        VStack(alignment: .leading) {
                            Text("Epsilon")
                                .font(.headline)
                            Slider(value: $settingStore.epsilon, in: 0.0...1.0, step: 0.01)
                            Text("Epsilon: \(settingStore.epsilon, specifier: "%.2f")")
                        }
                        .frame(width: 300)
                        .padding(.top, 10)
                        
                        Text("Choose whether the agent focuses only on actions with the highest rewards (true) or occasionally explores other options (false). A greedy strategy ignores the epsilon value.")
                            .font(.title2)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                        
                        Toggle("Greedy", isOn: $settingStore.isGreedy)
                            .font(.headline)
                            .padding()
                            .frame(width: 300)
                        
                        Text("Customize the environment's behavior by setting the slipperiness. When true, the agent may slide and not always move as intended, making navigation more challenging.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        
                        Toggle("Slippery", isOn: $settingStore.isSlippery)
                            .font(.headline)
                            .padding()
                            .frame(width: 300)
                    }
                    
                    
                    if isWelcome {
                        NavigationLink(destination: WelcomeView5()) {
                            Text("Next")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                    
                    Spacer()
                }
//                .frame(width: .infinity, height: .infinity, alignment: .center)
                .padding(.horizontal, 100)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView5: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .center, spacing: 40){
                    Spacer()
                    Text("Take Control 🕹️")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("Take control of the simulation by starting, stopping, speeding up, or slowing down the learning process at your own pace. ")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Text("You can also move the simulation step by step, in order to see the changes more clearly!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Rounds: \(statStore.episodes)")
                            .font(.headline)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 0)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            
                            CustomButton(normalImage: Image("Reset_button"), pressedImage: Image("Reset_button_pressed")) {
                                modelStore.agent.pause()
                                modelStore.agent.reset()
                                modelStore.environment.resetBoard()
                                statStore.reset()
                            }
                            
                            CustomButton(normalImage: Image("Step_button"), pressedImage: Image("Step_button_pressed")) {
                                modelStore.agent.move()
                            }
                            if settingStore.gameState == GameState.paused {
                                CustomButton(normalImage: Image("Play_button"), pressedImage: Image("Play_button_pressed")) {
                                    modelStore.agent.toggleAutoPlay()
                                }
                            } else {
                                CustomButton(normalImage: Image("Pause_button"), pressedImage: Image("Pause_button_pressed")) {
                                    modelStore.agent.toggleAutoPlay()
                                }
                            }
                            
                            CustomButton(normalImage: Image("Forward_button"), pressedImage: Image("Forward_button_pressed")) {
                                modelStore.agent.incrementSpeed()
                                modelStore.environment.reset()
                            }
                        }
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                    }
                    .frame(width: 700)
                    
                    BoardView(width: 700, environment: modelStore.environment, agent: modelStore.agent)
                    
                    Text("Heads up: Running the simulation at max speed can cause some lag in the interface.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Text("Feel free to reset the board and agent anytime for a fresh start!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    if isWelcome {
                        NavigationLink(destination: WelcomeView6()) {
                            Text("Next")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 100)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView6: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .center, spacing: 40){
                    Spacer()
                    Text("Dive into the Stats 📊")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("Track your agent's performance with insightful statistics!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text("A successful round is when our sly fox snatches an apple!")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Text("Watch your agent get closer to the optimal success rate as it learns the ropes. This is the theoretical maximum.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    StatView()
                        .frame(width: 1100)
                    
                    Text("In case your agent is not performing well, adjust the epsilon to explore new states temporarily, and later reduce it together with the alpha to capitalize on high-value actions.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    
                    if isWelcome {
                        NavigationLink(destination: WelcomeView7()) {
                            Text("Next")
                                .font(.title3)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 100)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView7: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    private let isWelcome: Bool
    
    init(isWelcome: Bool = true) {
        self.isWelcome = isWelcome
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 40){
                Spacer()
                Text("You Made It! 🎉")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("If you have any doubts, the handy-dandy built-in wiki has your back!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                if isWelcome {
                    NavigationLink(destination: PlaygroundView()) {
                        Text("Let's Get Started! 🚀")
                            .font(.title3)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 100)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView8: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var modelStore: ModelStore
    @EnvironmentObject var statStore: StatStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 40) {
                    Spacer()
                    Text("Credits 🌟")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("All resources utilized in this app are available under free/open licenses. These resources have been employed to enhance the user experience.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text("A huge thank you to these amazing individuals for providing the assets:")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .center) {
                            Text("•")
                            HStack(spacing: 8) {
                                Link("Frozen Lake tileset", destination: URL(string: "https://opengameart.org/content/animated-water-tiles-0")!)
                                Text("- modified Sevarihk's ocean autotiles")
                                Link("(CC BY-NC 4.0)", destination: URL(string: "https://creativecommons.org/licenses/by-nc/4.0/")!)
                            }
                        }
                        .font(.title2)
                        
                        HStack(alignment: .center) {
                            Text("•")
                            HStack(spacing: 8) {
                                Link("Fox Sprite", destination: URL(string: "https://elthen.itch.io/2d-pixel-art-fox-sprites")!)
                                Text("- Elthen")
                                Link("(CC BY-NC 4.0)", destination: URL(string: "https://creativecommons.org/licenses/by-nc/4.0/")!)
                            }
                        }
                        .font(.title2)
                        
                        HStack(alignment: .center) {
                            Text("•")
                            HStack(spacing: 8) {
                                Link("Apple Sprite", destination: URL(string: "https://clowwny.itch.io/fruits-icons-pixelart")!)
                                Text("- Clowwny")
                                Link("(CC BY-NC 4.0)", destination: URL(string: "https://creativecommons.org/licenses/by-nc/4.0/")!)
                            }
                        }
                        .font(.title2)
                        
                        HStack(alignment: .center) {
                            Text("•")
                            HStack(spacing: 8) {
                                Link("Buttons", destination: URL(string: "https://ok-lavender.itch.io/free-pixel-art-button-pack")!)
                                Text("- ok_lavender")
                                Link("(CC BY-NC 4.0)", destination: URL(string: "https://creativecommons.org/licenses/by-nc/4.0/")!)
                            }
                        }
                        .font(.title2)
                        
                    }
                    Spacer()
                }
                .padding(.horizontal, 100)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}
