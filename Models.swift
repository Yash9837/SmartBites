import Foundation

struct FoodEntry: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: Int
    let emoji: String
}
//
//struct DailyChallenge: Identifiable, Codable {
//    let id = UUID()
//    let title: String
//    var isCompleted: Bool
//}
struct StreakHistory: Identifiable, Codable {
    let id = UUID()
    let date: String
    let calories: Int
}


struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let name: String
    var score: Int
}
