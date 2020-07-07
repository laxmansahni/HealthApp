//
//  HealthKitManager.swift
//  HealthApp
//
//  Created by Laxman Sahni on 03/07/20.
//  Copyright © 2020 Laxman Sahni. All rights reserved.
//

import HealthKit

class HealthKitManager {
    fileprivate let healthKitStore = HKHealthStore()
    func authorizationRequestHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        // 1
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.chariotsolutions.mobile", code: 999,
                                userInfo: [NSLocalizedDescriptionKey : "Healthkit not available on this device"])
            completion(false, error)
            print("HealthKit not available on this device")
            return
        }
        // 2
        let readTypes: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
                                            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
                                            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        let writeTypes: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
                                             HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
                                             HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        // 3
        healthKitStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success: Bool, error: Error?) in
            completion(success, error)
        }
    }
    func saveBloodPressureMeasurement(systolic: Int, diastolic: Int, heartRate: Int, completion: @escaping (Bool, Error?) -> Void) {
        // 1
        let startDate = Date()
        let endDate = startDate
        // 2
        let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let systolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(systolic))
        let systolicSample = HKQuantitySample(type: systolicType, quantity: systolicQuantity, start: startDate, end: endDate)
        let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let diastolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(diastolic))
        let diastolicSample = HKQuantitySample(type: diastolicType, quantity: diastolicQuantity, start: startDate, end: endDate)
        // 3
        let bpCorrelationType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
        let bpCorrelation = Set<HKSample>(arrayLiteral: systolicSample, diastolicSample)
        let bloodPressureSample = HKCorrelation(type: bpCorrelationType , start: startDate, end: endDate, objects: bpCorrelation)
        // 4
        let beatsCountUnit = HKUnit.count()
        let heartRateQuantity = HKQuantity(unit: beatsCountUnit.unitDivided(by: HKUnit.minute()), doubleValue: Double(heartRate))
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let heartRateSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, start: startDate, end: endDate)
        // 5
        healthKitStore.save([bloodPressureSample, heartRateSample]) { (success: Bool, error: Error?) in
            completion(success, error)
        }
    }
    
}
