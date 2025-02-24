//
//  HomeView.swift
//  SmartBites
//
//  Created by Yash's Mackbook on 23/02/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
   // ✅ Store user's name persistently
   @AppStorage("userName") private var userName: String = "Guest"
   
    // ✅ Streak & Calories Data
       @ObservedObject var streakVM = StreakHistoryViewModel()
       @State private var showStreakDetail = false
       @State private var showGraphView = false
       @State private var showProfileView = false  // ✅ New State for Profile
       @State private var totalCalories: Int = 1850  // Static for now
       @State private var dietQuality: String = "Balanced"

   var body: some View {
       ScrollView {
           VStack(spacing: -20) {  // ✅ Overlapping effect
                          // 🌅 1️⃣ Light Apple Health-Like Gradient Header
                          gradientHeader.offset(y: -80)
                          
                          // 🔥 2️⃣ Overlapping Streak Summary
                          streakSection
                              .offset(y: -130)  // ✅ Moves up to overlap
                          
               
               // 📊 3️⃣ Weekly Progress Graph (Opens Full Graph)
               weeklyProgressSection.offset(y: -80)
               
               // 🍎 4️⃣ Calories & Diet Summary
               caloriesDietSection.offset(y: -40)
           }
           .padding()
       }
       .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
   }
}
// MARK: - UI Components
extension HomeView {
    
    // ✅ 1️⃣ Light Apple Health-Like Gradient Header (Full Width)
    private var gradientHeader: some View {
        ZStack(alignment: .bottom) {
                   // Soft Apple Health-Style Gradient (Full Width)
                   LinearGradient(
                       gradient: Gradient(colors: [Color.pink.opacity(0.9), Color.orange.opacity(0.9)]), // ✅ Lightened
                       startPoint: .trailing, // ✅ From left edge to right edge
                       endPoint: .leading
                   )
                   .frame(width:400 ,height: 300) // ✅ Full width
                   .clipShape(RoundedCorner(radius: 40, corners: [.bottomLeft, .bottomRight])) // ✅ Rounded bottom corners
                   .edgesIgnoringSafeArea(.top)


            // Header Content
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello, \(userName) 👋")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Track your meals and stay healthy!")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    
                    // 👤 Profile Icon (Opens ProfileView)
                    Button(action: { showProfileView = true }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(height: 200)
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
    }
    
    // ✅ 2️⃣ Overlapping Streak Section
    private var streakSection: some View {
        VStack(alignment: .leading) {
            Text("🔥 Streak Summary")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)

            if streakVM.streakHistory.isEmpty {
                Text("No streak data yet. Start tracking meals! 📊")
                    .foregroundColor(.gray)
                    .padding(.bottom)
            } else {
                ForEach(streakVM.streakHistory.prefix(3)) { streak in
                    HStack {
                        Text(streak.date)
                        Spacer()
                        Text("\(streak.calories) kcal")
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
            }

            Button(action: { showStreakDetail = true }) {
                Text("View Full Streak History")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20) // ✅ Softer look
        .shadow(radius: 5)
        .padding(.horizontal)
        .sheet(isPresented: $showStreakDetail) {
            StreakDetailView(streakVM: streakVM)
        }
    }
    
    // ✅ 3️⃣ Weekly Progress Section
    private var weeklyProgressSection: some View {
        VStack {
            Text("📈 Weekly Progress")
                .font(.title2)
                .bold()
            
            Button(action: { showGraphView = true }) {
                WeeklyProgressChart()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
        .sheet(isPresented: $showGraphView) {
            WeeklyGraphView()
        }
    }
    
    // ✅ 4️⃣ Calories & Diet Summary Section
    private var caloriesDietSection: some View {
        HStack(spacing: 15) {
            HomeCardView(title: "📊 Calories Today", value: "\(totalCalories) kcal", color: .blue)
            HomeCardView(title: "🍎 Diet Quality", value: dietQuality, color: .green)
        }
        .padding(.horizontal)
    }
}

struct StreakView: View {
    var streakCount: Int
    @State private var progress: CGFloat = 0.0

    var body: some View {
        VStack {
            Text("🔥 \(streakCount)-Day Streak")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)

            ProgressView(value: progress, total: 30)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .frame(width: 200)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5)) {
                        progress = CGFloat(streakCount)
                    }
                }

            Text("Keep it up to reach 30 days!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

struct StreakDetailView: View {
    @ObservedObject var streakVM: StreakHistoryViewModel  // ✅ Use same instance from HomeView

    var body: some View {
        NavigationView {
            VStack {
                if streakVM.streakHistory.isEmpty {
                    Text("No streak data yet. Start tracking your meals! 📊")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(streakVM.streakHistory) { streak in
                        HStack {
                            Text(streak.date)
                            Spacer()
                            Text("\(streak.calories) kcal")
                                .bold()
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("🔥 Streak History")
            .onAppear {
                streakVM.loadStreaks()  // ✅ Ensure data loads
            }
        }
    }
}
// 📌 Custom Card View for Sections
struct HomeCardView: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

import Charts

struct WeeklyProgressChart: View {
    let weeklyData: [(day: String, calories: Int)] = [
        ("Mon", 1800), ("Tue", 2200), ("Wed", 2000),
        ("Thu", 2500), ("Fri", 2100), ("Sat", 2300), ("Sun", 1900)
    ]

    var body: some View {
        VStack {
            Text("📊 Weekly Calorie Progress")
                .font(.headline)
                .padding()

            Chart {
                ForEach(weeklyData, id: \.day) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Calories", data.calories)
                    )
                    .foregroundStyle(data.calories > 2200 ? .red : .blue)
                }
            }
            .frame(height: 200)
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}



class StreakHistoryViewModel: ObservableObject {
    @Published var streakHistory: [StreakHistory] = []
    @Published var currentStreak: Int = 0
    
    private let streakKey = "streakHistory"
    private let lastLoggedDateKey = "lastLoggedDate"

    init() {
           loadStreaks()
           if streakHistory.isEmpty {  // ✅ Add test data if empty
               addSampleData()
           }
       }
    func addSampleData() {
            streakHistory = [
                StreakHistory(date: "Feb 20, 2025", calories: 2200),
                StreakHistory(date: "Feb 21, 2025", calories: 2500),
                StreakHistory(date: "Feb 22, 2025", calories: 1800)
            ]
            saveStreaks()
        }
    func logStreak(calories: Int) {
        let today = formattedDate()

        // Prevent duplicate logging
        if let lastDate = UserDefaults.standard.string(forKey: lastLoggedDateKey), lastDate == today {
            return
        }

        // Check if yesterday was logged to continue streak
        if let lastDate = UserDefaults.standard.string(forKey: lastLoggedDateKey),
           let lastLogged = formattedDateToDate(lastDate),
           let todayDate = formattedDateToDate(today),
           Calendar.current.dateComponents([.day], from: lastLogged, to: todayDate).day == 1 {
            currentStreak += 1
        } else {
            currentStreak = 1
        }

        streakHistory.append(StreakHistory(date: today, calories: calories))
        saveStreaks()
        UserDefaults.standard.set(today, forKey: lastLoggedDateKey)
    }

     func saveStreaks() {
        if let encoded = try? JSONEncoder().encode(streakHistory) {
            UserDefaults.standard.set(encoded, forKey: streakKey)
        }
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
    }

   func loadStreaks() {
        if let savedData = UserDefaults.standard.data(forKey: streakKey),
           let decodedData = try? JSONDecoder().decode([StreakHistory].self, from: savedData) {
            streakHistory = decodedData
        }
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

   func formattedDateToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}
// 📌 Custom Shape for Rounded Header
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
