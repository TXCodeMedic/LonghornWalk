//
//  ViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        
        print("Inside ViewController")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view

        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            print("Inside activity manager")
            DispatchQueue.main.async {
                print("Checking activity")
                if activity.stationary {
                    print("Stationary")
                } else if activity.walking {
                    print("Walking")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }}}
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                
                DispatchQueue.main.async {
                    print(pedometerData.numberOfSteps.intValue)
                    self.stepLabel.text = "Steps: \(pedometerData.numberOfSteps.intValue)"
                }}}
        
    }
}
