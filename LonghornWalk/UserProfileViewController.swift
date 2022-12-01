//
//  UserProfileViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//

import UIKit
import AVFoundation
import CoreData


class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    let picker = UIImagePickerController()
    var profileCreated = false
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var joinDateLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // request authorization from the user for our app to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
//        do {
//          result = try context.fetch(fetchRequest)
//          for data in result as! [NSManagedObject] {
//            storedImageData.append(data.value(forKey: "storedImage") as! Data)
//          }
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        let image = UIImage(data: storedImageData)
//        NSString(appDelegate.currentUser?.points)
        
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        profilePhoto.image = appDelegate.currentUser?.profilePic
        displayNameLabel.text = appDelegate.currentUser?.displayName
        joinDateLabel.text = appDelegate.currentUser?.joinDate
        emailLabel.text = appDelegate.currentUser?.userEmail
        pointsLabel.text = "\(String(describing: appDelegate.currentUser?.points))"
    }
    

    @IBAction func editProfile(_ sender: Any) {
    }
}


