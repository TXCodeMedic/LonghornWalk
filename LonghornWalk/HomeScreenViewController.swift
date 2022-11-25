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
    
    //Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    //Variables
    var delegate: UIViewController!
    var user:[theUser] = []
    
    let queue1 = DispatchQueue(label: "background thread", qos: .background)
        
    override func viewDidLoad() {
        print("\nhomeScreenVC\n")
        super.viewDidLoad()
    
        let fetchedResults = retrieveUser()
        if fetchedResults != [] {
            let username:String = (fetchedResults[0].value(forKey: "username"))! as! String
            let displayName:String = (fetchedResults[0].value(forKey: "displayName"))! as! String
            let email:String = (fetchedResults[0].value(forKey: "email"))! as! String
            let password:String = (fetchedResults[0].value(forKey: "password"))! as! String
            
            print("show user attributes:")
            print("username: \(username)" )
            print("displayName: \(displayName)" )
            print("email: \(email)" )
            print("password: \(password)" )
            
            let currentUser = theUser(userEmail: email, username: username, password: password, displayName: displayName)
            user.append(currentUser)
            print("added user to user list")
            // Change elements on the Screen
            
            
        } else{
            print("Error retrieving user")
        }
        
        
        // multithreading
        queue1.async {
            while true{
                // sleep for 5 seconds
                sleep(5)
                print("5 seconds passed")
                // get steps
                print(CMPedometer.isStepCountingAvailable())
                if CMPedometer.isStepCountingAvailable() {
                    pedometer.startUpdates(from: Date()) { pedometerData, error in
                        guard let pedometerData = pedometerData, error == nil else { return }
                        // step count
                        var stepCout = pedometerData.numberOfSteps.intValue
                        print(stepCout)
                        print(self.user)
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
