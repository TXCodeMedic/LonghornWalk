//
//  UserProfileViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit
import AVFoundation
import CoreData

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var profileCreated = false
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var joinDateLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePhoto.backgroundColor = .systemGray6
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.black.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        profilePhoto.image = appDelegate.currentUser?.profilePic
        displayNameLabel.text = appDelegate.currentUser?.displayName
        joinDateLabel.text = appDelegate.currentUser?.joinDate
        emailLabel.text = appDelegate.currentUser?.userEmail
        var score = appDelegate.currentUser?.points
        score = Int(score!)
        pointsLabel.text = "Score: \(score!)"
        var userStatus = setStatus(score: score!)
        statusLabel.text = userStatus
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
        else if score >= 200 {
            return "Matthew McConaughey"
        }
        return ""
    }

    @IBAction func editProfile(_ sender: Any) {
    }
}
