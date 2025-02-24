import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // 🌅 Global Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.orange.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            // 📱 Tab Bar with Screens
            TabView {
                HomeView()       // 🏠 Dashboard
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                MealsView()      // 🍽 Meal Logging
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Meals")
                    }
                
                LeaderboardView() // 🏆 Leaderboard
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Leaderboard")
                    }
                
                ChallengesView() // 🎯 Daily Challenges
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Challenges")
                    }
                
                ProfileView()    // 👤 Profile
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .accentColor(.orange) // ✅ Modern Color Theme
        }
    }
}

