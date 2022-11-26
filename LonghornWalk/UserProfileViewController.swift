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
    
    @IBOutlet weak var createProfile: UIButton!
    
    @IBOutlet weak var editProfile: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // request authorization from the user for our app to send notifications
//        picker.delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
//            granted, error in
//            if granted {
//                print("All set!")
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        if currentUser.profilePic != nil {
            profilePhoto.image = currentUser.profilePic
        }
        
    }
    
    func viewDidAppear() {
        if profileCreated == false {
            editProfile.isHidden = true
            createProfile.isHidden = false
        }
        else if profileCreated == true {
            editProfile.isHidden = false
            createProfile.isHidden = true
        }
    }
    
    //TODO : Check if username exists in firebase, check if the username they entered isn't their own username, check if they entered anything at all when OK pressed
    @IBAction func onAddFriendPressed(_ sender: Any) {
        var okPressed = false
        var accepted = true
        // brings up an Alert where user inputs username of friend
        let friendInput = UIAlertController(
            title: "Add Friend",
            message: "Enter Username:",
            preferredStyle: .alert)
        // add the text field
        friendInput.addTextField {
            (textField) in
            textField.text = ""
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        friendInput.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                [weak friendInput] (_) in
                let textField = friendInput?.textFields![0] // Force unwrapping because we know it exists.
                print("Friend Requested: \(textField!.text!)")
                okPressed = true
                //print(okPressed)
                if okPressed == true {
                    self.dismiss(animated: true, completion: {
                        // If username is entered, exists in firebase, and isn't the same as the current user
                        let alert2 = UIAlertController(title: "Success!", message: "Your Friend Request was sent", preferredStyle: UIAlertController.Style.alert)
                        alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                    })
                    if accepted == true {
                        let notification_accepted = UNMutableNotificationContent()
                        notification_accepted.title = "Longhorn Walk:"
                        
                        notification_accepted.subtitle = "Congratulations!"
                        notification_accepted.body = "\(textField!.text!) accepted your friend request :)"
                        notification_accepted.sound = UNNotificationSound.default
                        // trigger the notification with a time interval of 8 seconds
                        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 8.0, repeats: false)
                        let request1 = UNNotificationRequest(identifier: "myNotification", content: notification_accepted, trigger: trigger1)
                        // add our notification to the notification center
                        UNUserNotificationCenter.current().add(request1)
                        accepted = false
                    }
//                    if accepted == false {
//                        // if friend request denied
//                        let notification_denied = UNMutableNotificationContent()
//                        notification_denied.title = "Longhorn Walk:"
//                        notification_denied.subtitle = "We are sorry!"
//                        notification_denied.body = "\(textField!.text!) denied your friend request :("
//                        notification_denied.sound = UNNotificationSound.default
//                        // trigger the notification with a time interval of 8 seconds
//                        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 16.0, repeats: false)
//                        let request2 = UNNotificationRequest(identifier: "myNotification", content: notification_denied, trigger: trigger2)
//                        // add our notification to the notification center
//                        UNUserNotificationCenter.current().add(request2)
//                    }
                }
                
        }))
        self.present(friendInput, animated: true, completion: nil)
        // ASK BILL how best to alternate between request accpeted and denied notifications
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let chosenImage = info[.originalImage] as! UIImage
//        profilePhoto.contentMode = .scaleAspectFit
//        profilePhoto.image = chosenImage
//        currentUser.profilePic = chosenImage
//        dismiss(animated: true)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }
    
//    @IBAction func changePhotoPressed(_ sender: Any) {
//        let controller = UIAlertController(
//            title: "Choose your Profile Photo",
//            message: "Take from:",
//            preferredStyle: .actionSheet)
//        // if regular cheese option is selected, make that the cheese type of the pizza object
//        let Camera = UIAlertAction(
//            title: "Camera",
//            style: .default,
//            handler: {_ in
//                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
//                    // use the rear camera
//                    switch AVCaptureDevice.authorizationStatus(for: .video) {
//                    case .notDetermined:
//                        // we don't know
//                        AVCaptureDevice.requestAccess(for: .video) {
//                            accessGranted in
//                            guard accessGranted == true else { return }
//                        }
//                    case .authorized:
//                        // we have permission already
//                        break
//                    default:
//                        // we know we don't have access
//                        print("Access denied")
//                        return
//                    }
//                self.picker.allowsEditing = false
//                self.picker.sourceType = .camera
//                self.picker.cameraCaptureMode = .photo
//                self.present(self.picker, animated: true)
//
//                } else {
//                    // no rear camera is available
//
//                    let alertVC = UIAlertController(
//                        title: "No camera",
//                        message: "Sorry, this device has no rear camera",
//                        preferredStyle: .alert)
//                    let okAction = UIAlertAction(
//                        title: "OK",
//                        style: .default)
//                    alertVC.addAction(okAction)
//                    self.present(alertVC,animated:true)
//                }
//            }
//        )
//
//            controller.addAction(Camera)
//        // if no cheese option is selected, make that the cheese type of the pizza object
//        let Library = UIAlertAction(
//            title: "Photo Library",
//            style: .default,
//            handler: {_ in
//                self.picker.allowsEditing = false
//                self.picker.sourceType = .photoLibrary
//                self.present(self.picker, animated: true)
//
//            })
//        controller.addAction(Library)
//
//        present(controller, animated: true)
//    }
    
    @IBAction func createProfile(_ sender: Any) {
        profileCreated = true
    }
    
    @IBAction func editProfile(_ sender: Any) {
    }
}
