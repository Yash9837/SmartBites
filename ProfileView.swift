//
//  ProfileView.swift
//  SmartBites
//
//  Created by Yash's Mackbook on 23/02/25.
//
import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = "John Doe"
    @AppStorage("userXP") private var userXP: Int = 120  // ✅ XP Tracking
    @AppStorage("streakCount") private var streakCount: Int = 5  // ✅ Streak Tracking
    @AppStorage("caloriesBurned") private var caloriesBurned: Int = 2200  // ✅ Calories Tracking
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 🌅 1️⃣ Profile Header with Gradient
            profileHeader.offset(y: -80)
            
            // 📊 2️⃣ Profile Stats Section
            profileStats.offset(y: -80)
            
            // ⚙️ 3️⃣ Settings & Options
            VStack(spacing: 15) {
                ProfileOption(title: "Edit Profile", icon: "pencil")
                ProfileOption(title: "App Settings", icon: "gear")
                ProfileOption(title: "Notifications", icon: "bell.fill")
              
                
            }.offset(y: -80)
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Profile")
    }
}

// MARK: - UI Components
extension ProfileView {
    
    // ✅ 1️⃣ Profile Header with Soft Gradient
    private var profileHeader: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.9), Color.orange.opacity(0.9)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width:400,height: 330)
            .clipShape(RoundedCorner(radius: 40, corners: [.bottomLeft, .bottomRight]))
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Text(userName)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("SmartBites User")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.bottom)
    }
    
    // ✅ 2️⃣ Profile Stats (XP, Streaks, Calories)
    private var profileStats: some View {
        HStack(spacing: 15) {
            ProfileStatCard(title: "🔥 Streak", value: "\(streakCount) Days", icon: "flame.fill", color: .orange)
            ProfileStatCard(title: "🏅 XP", value: "\(userXP) XP", icon: "star.fill", color: .yellow)
            ProfileStatCard(title: "🔥 Calories", value: "\(caloriesBurned) kcal", icon: "flame", color: .red)
        }
        .padding(.horizontal)
    }
}

// 📌 Profile Statistic Card
struct ProfileStatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(value)
                .font(.headline)
                .bold()
            
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// 📌 Profile Option Button
struct ProfileOption: View {
    var title: String
    var icon: String
    var isDestructive: Bool = false  // ✅ Handles logout styling
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : .blue)
                .frame(width: 30)
            
            Text(title)
                .font(.headline)
                .foregroundColor(isDestructive ? .red : .primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: isDestructive ? 0 : 2)
        .animation(.easeInOut(duration: 0.2), value: isDestructive)
    }
}

