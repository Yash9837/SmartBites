import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        VStack {
            // 🌅 Header
            Text("Welcome to SmartBites 🍏")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            Text("Track your meals, monitor your calories, and stay healthy!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()

            // 📜 Onboarding Features Section
            VStack(spacing: 20) {
                OnboardingFeature(image: "leaf.fill", title: "Track Your Meals", description: "Easily log what you eat and keep a daily food diary.")
                
                OnboardingFeature(image: "flame.fill", title: "Monitor Calories", description: "Stay on top of your calorie intake and diet trends.")
                
                OnboardingFeature(image: "star.fill", title: "Achieve Goals", description: "Complete challenges, earn rewards, and stay motivated!")
            }
            .padding(.horizontal, 20)

            Spacer()

            // ✅ Get Started Button
            Button(action: {
                hasSeenOnboarding = true  // ✅ Mark onboarding as seen
            }) {
                Text("Get Started")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// 📌 Onboarding Feature Item
struct OnboardingFeature: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

