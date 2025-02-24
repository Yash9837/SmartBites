import UserNotifications

class ReminderManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    static func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🏆 Daily Challenge"
        content.body = "Don't forget to complete today's challenge!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 8 // Reminder at 8 AM

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyChallengeReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}

