//
//  DailyChallengeView.swift
//  SmartBites
//
//  Created by Yash's Mackbook on 23/02/25.
//

import SwiftUI

// 🎯 Daily Challenge Model
struct DailyChallenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
}

// 🎯 Challenge ViewModel with Points & Streak Tracking
class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: DailyChallenge?
    @AppStorage("challengePoints") var challengePoints: Int = 0 // ✅ Store points
    @AppStorage("challengeStreak") var challengeStreak: Int = 0 // ✅ Track streak
    @AppStorage("lastChallengeDate") var lastChallengeDate: String = ""

    private let challengeKey = "dailyChallenge"
    private let challengeList: [DailyChallenge] = [
        DailyChallenge(title: "Eat a fruit today! 🍏", isCompleted: false),
        DailyChallenge(title: "Drink 8 glasses of water 💧", isCompleted: false),
        DailyChallenge(title: "Avoid junk food today! 🚫🍕", isCompleted: false),
        DailyChallenge(title: "Eat a protein-rich meal 🍗", isCompleted: false),
        DailyChallenge(title: "Have a vegetable with every meal 🥦", isCompleted: false)
    ]

    init() {
        loadChallenge()
    }

    func loadChallenge() {
        let today = formattedDate()

        if today != lastChallengeDate {
            generateNewChallenge()
            lastChallengeDate = today
        } else if let savedData = UserDefaults.standard.data(forKey: challengeKey),
                  let decodedChallenge = try? JSONDecoder().decode(DailyChallenge.self, from: savedData) {
            currentChallenge = decodedChallenge
        }
    }

    func generateNewChallenge() {
        currentChallenge = challengeList.randomElement()
        saveChallenge()
    }

    func completeChallenge() {
        guard var challenge = currentChallenge, !challenge.isCompleted else { return }
        challenge.isCompleted = true
        currentChallenge = challenge

        // ✅ Update points & streak
        challengePoints += 10
        challengeStreak += 1
        saveChallenge()
    }

    private func saveChallenge() {
        if let encoded = try? JSONEncoder().encode(currentChallenge) {
            UserDefaults.standard.set(encoded, forKey: challengeKey)
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

// 🎯 Challenges Screen
struct ChallengesView: View {
    @ObservedObject var challengeVM = ChallengeViewModel()
    @State private var showConfetti = false

    var body: some View {
        VStack(spacing: 20) {
            
            // 🎯 Header
            VStack {
                Text("🎯 Daily Challenge")
                    .font(.largeTitle)
                    .bold()
                
                Text("Stay consistent & earn rewards!")
                    .foregroundColor(.gray)
            }
            .padding(.top)

            // 🏆 Points & Streak Progress
            HStack {
                ProgressView(value: Double(challengeVM.challengeStreak), total: 30)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 150)
                
                VStack {
                    Text("🔥 Streak: \(challengeVM.challengeStreak) days")
                        .font(.headline)
                    Text("🏅 Points: \(challengeVM.challengePoints)")
                        .foregroundColor(.gray)
                }
            }
            .padding()

            // 🎉 Confetti Effect on Completion
            ZStack {
                if showConfetti {
                    ConfettiView()
                        .transition(.opacity)
                        .zIndex(1)
                }
                
                DailyChallengeView(showConfetti: $showConfetti)
            }

            Spacer()
        }
        .padding()
    }
}

// 🎯 Individual Daily Challenge View
struct DailyChallengeView: View {
    @ObservedObject var challengeVM = ChallengeViewModel()
    @Binding var showConfetti: Bool  // ✅ Controls confetti effect

    var body: some View {
        VStack {
            if let challenge = challengeVM.currentChallenge {
                Text("")
                    .font(.headline)
                
                Text(challenge.title)
                    .font(.title2)
                    .bold()
                    .padding()
                    .background(challenge.isCompleted ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                    .cornerRadius(10)

                Button(action: {
                    challengeVM.completeChallenge()
                    showConfetti = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showConfetti = false
                    }
                }) {
                    Text(challenge.isCompleted ? "✅ Completed" : "Mark as Done")
                        .padding()
                        .background(challenge.isCompleted ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .animation(.easeInOut(duration: 0.3), value: challenge.isCompleted)
                }
                .disabled(challenge.isCompleted)
            }
        }
        .padding()
    }
}
//
//// 🎉 Confetti Effect (Celebration Animation)
//struct ConfettiView: View {
//    @State private var particles: [ConfettiParticle] = []
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                ForEach(particles) { particle in
//                    Circle()
//                        .frame(width: particle.size, height: particle.size)
//                        .foregroundColor(particle.color)
//                        .position(x: particle.position.x, y: particle.position.y)
//                        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: particle.position)
//                }
//            }
//            .onAppear {
//                for _ in 0..<20 {
//                    let x = CGFloat.random(in: 0...geo.size.width)
//                    let y = CGFloat.random(in: -50...50)
//                    let size = CGFloat.random(in: 5...15)
//                    let colors: [Color] = [.red, .blue, .yellow, .green, .pink, .purple]
//                    let color = colors.randomElement() ?? .blue
//                    particles.append(ConfettiParticle(id: UUID(), position: CGPoint(x: x, y: y), size: size, color: color))
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    particles.removeAll()
//                }
//            }
//        }
//    }
//}
//
//// 🎉 Confetti Particle Model
//struct ConfettiParticle: Identifiable {
//    let id: UUID
//    var position: CGPoint
//    var size: CGFloat
//    var color: Color
//}
