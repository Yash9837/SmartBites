//
//  MealsView.swift
//  SmartBites
//
//  Created by Yash's Mackbook on 23/02/25.
//

import Foundation
import SwiftUI

struct MealsView: View {
    @State private var foodEntries: [FoodEntry] = []  // ✅ Stores logged meals
    @State private var totalCalories: Int = 0  // ✅ Tracks daily calorie intake
    @State private var showLogMeal = false

    let dailyCalorieGoal = 2200  // ✅ Set a daily goal

    var progress: CGFloat {
        return min(CGFloat(totalCalories) / CGFloat(dailyCalorieGoal), 1.0)  // ✅ Limits progress to 100%
    }

    var calorieStatus: String {
        if totalCalories < dailyCalorieGoal * Int(0.8) {
            return "You're under your calorie goal. Consider eating more! 🥗"
        } else if totalCalories <= dailyCalorieGoal {
            return "You're on track! Keep it up! ✅"
        } else {
            return "You've exceeded your calorie goal! Be mindful! ⚠️"
        }
    }

    var progressColor: Color {
        if totalCalories < dailyCalorieGoal * Int(0.8) {
            return .blue  // ✅ Blue: Under Goal
        } else if totalCalories <= dailyCalorieGoal {
            return .green  // ✅ Green: On Track
        } else {
            return .red  // ✅ Red: Over Goal
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("🍽 Your Meals")
                .font(.largeTitle)
                .bold()

            // 🔢 Calorie Progress Indicator
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 15) // ✅ Background circle
                        .frame(width: 150, height: 150)

                    Circle()
                        .trim(from: 0.0, to: progress) // ✅ Animated Progress
                        .stroke(progressColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .rotationEffect(.degrees(-90)) // ✅ Start from top
                        .frame(width: 150, height: 150)
                        .animation(.easeInOut(duration: 0.5), value: progress)

                    VStack {
                        Text("\(totalCalories)")
                            .font(.title)
                            .bold()
                        Text("kcal")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Text(calorieStatus) // ✅ Dynamic message
                    .font(.subheadline)
                    .foregroundColor(progressColor)
                    .padding(.top, 5)
            }
            .padding()

            // 🍎 Meal List
            List(foodEntries) { meal in
                HStack {
                    Text(meal.emoji)
                        .font(.title)
                    Text(meal.name)
                        .font(.headline)
                    Spacer()
                    Text("\(meal.calories) kcal")
                        .foregroundColor(.gray)
                }
            }

            // ➕ Log a Meal Button
            Button(action: { showLogMeal = true }) {
                Text("➕ Log a Meal")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            .padding()
            .sheet(isPresented: $showLogMeal) {
                LogMealView(foodEntries: $foodEntries, totalCalories: $totalCalories)
            }

            Spacer()
        }
        .padding()
    }
}

struct LogMealView: View {
    @Binding var foodEntries: [FoodEntry]  // ✅ Updates MealsView
    @Binding var totalCalories: Int  // ✅ Updates calorie progress
    @Environment(\.dismiss) var dismiss  // ✅ Allows closing the view

    let meals = [
        ("Apple", 95, "🍏"), ("Pizza", 285, "🍕"), ("Salad", 150, "🥗"),
        ("Burger", 354, "🍔"), ("Rice", 206, "🍚"), ("Pasta", 220, "🍝"),
        ("Egg", 68, "🥚"), ("Banana", 105, "🍌"), ("Chicken", 335, "🍗")
    ]

    var body: some View {
        VStack {
            Text("🍽 Log Your Meal")
                .font(.largeTitle)
                .bold()
                .padding()

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(meals, id: \.0) { meal in
                        Button(action: {
                            let newMeal = FoodEntry(name: meal.0, calories: meal.1, emoji: meal.2)
                            foodEntries.append(newMeal)  // ✅ Add meal
                            totalCalories += meal.1  // ✅ Update calories
                            dismiss() // ✅ Close view
                        }) {
                            HStack {
                                Text(meal.2) // ✅ Emoji
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(meal.0)
                                        .font(.headline)
                                    Text("\(meal.1) kcal")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }

            Spacer()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

