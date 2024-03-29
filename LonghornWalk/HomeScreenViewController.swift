//
//  HomeScreenViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit
import CoreData
import CoreMedia
import FirebaseAuth

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
// identifier for a cell from tableView
let textCellIdentifier = "textCellIdentifier"
// segue identifier for Location VC
let locationSegue = "locationVCsegue"

public class Location {
    var locationName: String
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
    @IBOutlet weak var displayNameLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var profileButton: UIBarButtonItem!

    @IBOutlet weak var locationButton: UIBarButtonItem!

    
    //Variables
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        var currentDate = Date()
        var formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        var formattedDate = formatter.string(from: currentDate)
        if appDelegate.currentUser?.lastUpdate as! String != formattedDate as? String {
            let alert = UIAlertController(
                title: "New Day!",
                message: "We refreshed your list!\nGo get more points!",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            self.present(alert, animated: true)
            clearCoreData()
            appDelegate.currentUser?.lastUpdate = formattedDate
            appDelegate.currentUser?.saveUser()
        }
        var score = appDelegate.currentUser?.points
        var displayName = appDelegate.currentUser?.displayName
        var userStatus = setStatus(score: score!)
        score = Int(score!)
        scoreLabel.text = "Score: \(score!)"
        displayNameLabel.text = "\(displayName!)"
        levelLabel.text = "Status Level: \(userStatus)"
        profilePic.image = appDelegate.currentUser?.profilePic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var score = appDelegate.currentUser?.points
        var displayName = appDelegate.currentUser?.displayName
        var userStatus = setStatus(score: score!)
        scoreLabel.text = "Score: \(score!)"
        displayNameLabel.text = "\(displayName!)"
        levelLabel.text = "Status Level: \(userStatus)"
        profilePic.image = appDelegate.currentUser?.profilePic
    }
    
    @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
        // this is intentionally blank
    }
    
    // CORE DATA:
    // store location in core data
    func storeLocation(location: UTLocation) {
        let newLoc = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)
        newLoc.setValue(location.locationName, forKey: "locationName")
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
    
    //MARK: Set Status
    func setStatus(score:Int) -> String{
        // set status
        if score >= 0 && score < 50 {
            return "Bevo Beginner"
        }
        else if score >= 50 && score < 100 {
            return "Owen Wilson"
        }
        else if score >= 100 && score < 150 {
            return "Wes Anderson"
        }
        else if score >= 150 && score < 200 {
            return "Neil deGrasse Tyson"
        }
        else if score >= 200 && score < 250{
            return "Matthew McConaughey"
        }
        else if score >= 250 && score < 300{
            return "Farrah Fawcett"
        }
        else if score >= 300 && score < 350{
            return "Kevin Durant"
        }
        else if score >= 350{
            return "Bill Bulko"
        }
        return ""
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
        cell.iconImageView.image = UIImage(named: "\(fetchedResults[row].value(forKey: "locationName")!)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        let fetchedResults = retrieveLocation()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "popupLocationViewController") as? popupLocationViewController {
            vc.image = UIImage(named: "\(fetchedResults[indexPath.row].value(forKey: "locationName")!)")!
            vc.name = "\(fetchedResults[indexPath.row].value(forKey: "locationName")!)"
            //self.navigationController?.pushViewController(vc, animated: true)
            show(vc, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func onLogoutPressed(_ sender: Any) {
        do {
            // sign out of firebase auth
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
        }
    }
    
}
