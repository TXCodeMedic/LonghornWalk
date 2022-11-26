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
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var delegate: UIViewController!
    var user:[User] = []
            
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
            
            //MARK: USER CLASS INIT
            currentUser = User(userEmail: email, username: username, password: password, displayName: displayName)
            user.append(currentUser)
            print("added user to user list")
            // Change elements on the Screen
            
        } else{
            print("Error retrieving user")
        }
        
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
                    self.scoreLabel.text = "\(pedometerData.numberOfSteps.intValue)"
                }}}
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
