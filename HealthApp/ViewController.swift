//
//  ViewController.swift
//  HealthApp
//
//  Created by Laxman Sahni on 03/07/20.
//  Copyright © 2020 Laxman Sahni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
    }


    private func authorizeHealthKit() {
      
      HealthKitManager().authorizationRequestHealthKit { (authorized, error) in
        
        guard authorized else {
          
          let baseMessage = "HealthKit Authorization Failed"
          
          if let error = error {
            self.showSimpleAlert(title: "HealthKit Authorization",
            message: "\(baseMessage). Reason: \(error.localizedDescription)")
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
          
          return
        }
        DispatchQueue.main.async  {
                    self.showSimpleAlert(title: "HealthKit Authorization",
                                         message: "HealthKit Successfully Authorized.")
                }
        print("HealthKit Successfully Authorized.")
      }
      
    }
    
    @IBAction func recordBlodPressureClicked(_ sender: Any) {

          HealthKitManager().saveBloodPressureMeasurement(systolic: 120, diastolic: 80, heartRate: 60) { (success, error) in
          
          guard success else {
            
            let baseMessage = "Error Saving Blood Pressure Sample"
            
            if let error = error {
                self.showSimpleAlert(title: "Error In Saving Blood Pressure",
                message: "\(baseMessage). Reason: \(error.localizedDescription)")
              print("\(baseMessage). Reason: \(error.localizedDescription)")
            } else {
              print(baseMessage)
            }
            
            return
          }
          DispatchQueue.main.async  {
              self.showSimpleAlert(title: "Saved Blood Pressure",
                                   message: "Successfully saved Blood Pressure Sample")
          }
          print("Successfully saved Blood Pressure Sample")
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}

