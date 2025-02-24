import SwiftUI

@main
struct SmartBitesApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()  // ✅ Show main app after onboarding
            } else {
                SplashScreen()
            }
        }
    }
}

