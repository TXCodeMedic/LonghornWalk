//
//  HomeScreenViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//

import UIKit
import CoreData

import CoreMotion

// Provides to create an instance of the CMMotionActivityManager.
// !!! monitors activity type like walking running or automative
private let activityManager = CMMotionActivityManager()

// Provides to create an instance of the CMPedometer.
// !!! gets current step count
private let pedometer = CMPedometer()


class HomeScreenViewController: UIViewController {
    
    let queue1 = DispatchQueue(label: "background thread", qos: .background)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchedResults = retrieveUser()
        // !! this only receives info from the first entity ever created, fetchedResults[0]
        var userEmail = fetchedResults[0].value(forKey: "email")
        var userPassword = fetchedResults[0].value(forKey: "password")
        var userUsername = fetchedResults[0].value(forKey: "username")
        var displayName = fetchedResults[0].value(forKey: "displayName")
        
        
        // multithreading
        queue1.async {
            while true{
                // sleep for 5 seconds
                sleep(5)
                // get steps
                if CMPedometer.isStepCountingAvailable() {
                    pedometer.startUpdates(from: Date()) { pedometerData, error in
                        guard let pedometerData = pedometerData, error == nil else { return }
                        // step count
                        var stepCout = pedometerData.numberOfSteps.intValue
                        // TO DO: update user score in class
                        
                        // TO DO: update user score in DB
                    }
                }
                DispatchQueue.main.sync{
                    // update UI
                    // update score label
                    
                }
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    //retrieve from core data
    func retrieveUser() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        return(fetchedResults)!
    }
    
    
    

    

}
