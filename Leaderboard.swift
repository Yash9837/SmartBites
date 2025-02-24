
import SwiftUI

//// 🏆 Leaderboard Entry Model
//struct LeaderboardEntry: Identifiable, Codable {
//    let id = UUID()
//    var name: String
//    var score: Int
//}

// 🏆 Leaderboard ViewModel with XP Points & Ranks
class LeaderboardViewModel: ObservableObject {
    @Published var leaderboard: [LeaderboardEntry] = []
    private let leaderboardKey = "leaderboardData"
    
    @AppStorage("userName") var userName: String = "Guest"
    @AppStorage("userXP") var userXP: Int = 0  // ✅ Track XP
    @State private var showConfetti = false

    init() {
        loadLeaderboard()
    }

    func addPoints(user: String, points: Int) {
        if let index = leaderboard.firstIndex(where: { $0.name == user }) {
            leaderboard[index].score += points
        } else {
            leaderboard.append(LeaderboardEntry(name: user, score: points))
        }
        
        leaderboard.sort { $0.score > $1.score }
        saveLeaderboard()
    }

    private func saveLeaderboard() {
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: leaderboardKey)
        }
    }

    private func loadLeaderboard() {
        if let savedData = UserDefaults.standard.data(forKey: leaderboardKey),
           let decodedData = try? JSONDecoder().decode([LeaderboardEntry].self, from: savedData) {
            leaderboard = decodedData
        }
    }
}

// 🏆 Leaderboard View
struct LeaderboardView: View {
    @ObservedObject var leaderboardVM = LeaderboardViewModel()
    @State private var showConfetti = false  // ✅ Celebration Effect

    var body: some View {
        VStack {
            // 🎉 Confetti Celebration
            if showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
            
            // 🏆 Title
            Text("🏆 Leaderboard")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // 🏅 User XP & Level
            VStack {
                Text("Your XP: \(leaderboardVM.userXP)")
                    .font(.headline)
                    .padding(5)
                
                ProgressView(value: Double(leaderboardVM.userXP % 100), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 200)
                
                Text("Level: \(leaderboardVM.userXP / 100)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            // 📜 Leaderboard List
            List(leaderboardVM.leaderboard.indices, id: \.self) { index in
                HStack {
                    Text(rankIcon(index))
                        .font(.title2)
                    
                    Text(leaderboardVM.leaderboard[index].name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(leaderboardVM.leaderboard[index].score) pts")
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding(5)
            }
            
            // 🎯 Gain XP Button
            Button(action: {
                leaderboardVM.addPoints(user: leaderboardVM.userName, points: 10)
                leaderboardVM.userXP += 10
                showConfetti = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showConfetti = false
                }
            }) {
                Text("🎯 Gain XP (10 pts)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            .padding()
        }
    }

    // 🏅 Assign Rank Icons
    private func rankIcon(_ index: Int) -> String {
        switch index {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return "🏅"
        }
    }
}

// 🎉 Confetti Effect (Celebration Animation)
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .frame(width: particle.size, height: particle.size)
                        .foregroundColor(particle.color)
                        .position(x: particle.position.x, y: particle.position.y)
                        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: particle.position)
                }
            }
            .onAppear {
                for _ in 0..<20 {
                    let x = CGFloat.random(in: 0...geo.size.width)
                    let y = CGFloat.random(in: -50...50)
                    let size = CGFloat.random(in: 5...15)
                    let colors: [Color] = [.red, .blue, .yellow, .green, .pink, .purple]
                    let color = colors.randomElement() ?? .blue
                    particles.append(ConfettiParticle(id: UUID(), position: CGPoint(x: x, y: y), size: size, color: color))
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    particles.removeAll()
                }
            }
        }
    }
}

// 🎉 Confetti Particle Model
struct ConfettiParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var color: Color
}
