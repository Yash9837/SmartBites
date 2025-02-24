//import HealthKit
//
//class HealthKitManager {
//    static let shared = HealthKitManager()
//    private let healthStore = HKHealthStore()
//
//    let readTypes: Set = [
//        HKQuantityType.quantityType(forIdentifier: .stepCount)!,
//        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
//    ]
//    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
//            guard HKHealthStore.isHealthDataAvailable() else {
//                completion(false, NSError(domain: "HealthKit not available", code: 1, userInfo: nil))
//                return
//            }
//
//            healthStore.requestAuthorization(toShare: nil, read: readTypes, completion: completion)
//        }
//
//    func fetchSteps(completion: @escaping (Int) -> Void) {
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
//            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
//            completion(Int(steps))
//        }
//        healthStore.execute(query)
//    }
//
//    func fetchCalories(completion: @escaping (Double) -> Void) {
//        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
//        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
//            let calories = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
//            completion(calories)
//        }
//        healthStore.execute(query)
//    }
//}
//
