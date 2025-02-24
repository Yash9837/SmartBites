import SwiftUI
import Charts

struct WeeklyGraphView: View {
    let weeklyCalories: [(String, Int)] = [
        ("Mon", 1800), ("Tue", 2100), ("Wed", 2200),
        ("Thu", 1900), ("Fri", 2300), ("Sat", 2500), ("Sun", 2000)
    ]  // ✅ Static calorie data

    var body: some View {
        VStack {
            Text("📊 Weekly Calorie Breakdown")
                .font(.largeTitle)
                .bold()
                .padding()

            Chart {
                ForEach(weeklyCalories, id: \.0) { data in
                    BarMark(
                        x: .value("Day", data.0),
                        y: .value("Calories", data.1)
                    )
                    .foregroundStyle(data.1 > 2200 ? .red : .green)
                }
            }
            .frame(height: 250)
            .padding()

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

