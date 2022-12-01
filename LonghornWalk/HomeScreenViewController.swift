//
//  HomeScreenViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//

import UIKit
import CoreData
import CoreMedia
import FirebaseAuth
import UserNotifications


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

// identifier for a cell from tableView
let textCellIdentifier = "textCellIdentifier"

// segue identifier for Location VC
let locationSegue = "locationVCsegue"

public class Location{
    var locationName:String
    init(){
        
        locationName = ""
      
    }
}

protocol addtoCoreData{
    func storeLocation(location:UTLocation)
    
    func refreshTable()
    
    func isRepeatingLocation(location:UTLocation)-> Bool
    
}

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, addtoCoreData {
    
    //Outlets
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var profileButton: UIButton!
  
    @IBOutlet weak var locationButton: UIButton!
    
    //Variables

    var delegate: UIViewController!
    
   

            
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
//        // ask for permission for local notifications
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
//            granted, error in
//            if granted{
//                print("all set!")
//            }else if let error = error{
//                print(error.localizedDescription)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        scoreLabel.text = "\(String(describing: appDelegate.currentUser?.points))"
        print("\nlook here")
        
        
    }
    
    // CORE DATA:
    
    // store location in core data
    func storeLocation(location: UTLocation) {
        print("storing a location")
        let newLoc = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)
    
        newLoc.setValue(location.locationName, forKey: "locationName")
//        newLoc.setValue(location.locationAddress, forKey: "locationAddress")
        //commit the changes
        saveContext()
    }
    // refresh table view
    func refreshTable() {
        self.tableView.reloadData()
    }
    
    // check if location is already in tableview
    func isRepeatingLocation(location: UTLocation) -> Bool {
        let fetchedResults = retrieveLocation()
        var itemIsRepeated = false
        
        for item in fetchedResults {
            if item.value(forKey: "locationName") as! String == location.locationName{
                itemIsRepeated = true
            }
        }
        print("item is repeated = \(itemIsRepeated)")
        return itemIsRepeated
    }
    
    // save to core data
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func checkDate(){
        // if date is different on Firestore, clear CoreData
        
    }
    
    //retrieve from core data
    func retrieveLocation() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        print("fetchedResults")
        print((fetchedResults)!)
        
        return(fetchedResults)!
    }
    
    // clear core data
    func clearCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "locationName")!) has been deleted")
                }
            }
            saveContext()
            
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == locationSegue,
           let nextVC = segue.destination as? LocationViewController{
            
            nextVC.delegate = self
            
        }
    }
    
    // table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return timers.count somehow
        let fetchedResults = retrieveLocation()
        return fetchedResults.count
    }
    

    
    
    // display of the cell contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fetchedResults = retrieveLocation()
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! myCellTableViewCell
    
       
        cell.locationName.text = "\(fetchedResults[row].value(forKey: "locationName")!)"
        return cell
    }
    
    
    
    
    
    
    @IBAction func onLogoutPressed(_ sender: Any) {
        do {
            // clear this user's locations visited
            clearCoreData()
            // sign out of firebase auth
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign Out error")
        }
    }
    
    
    
    
    
}
