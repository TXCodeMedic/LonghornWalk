//
//  EditProfileViewController.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/25/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit
import AVFoundation
import CoreData
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

protocol PhotoLoadProtocol {
    func photoLoaded()
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoLoadProtocol {
    
    let picker = UIImagePickerController()
    
    let db = Firestore.firestore()
    
    var chosenImage: UIImage? = nil
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var displayNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        profilePic.backgroundColor = .systemGray6
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.image = appDelegate.currentUser?.profilePic
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayNameText.text = appDelegate.currentUser?.displayName
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = info[.originalImage] as? UIImage
        profilePic.image = chosenImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    @IBAction func changePhotoPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Choose your Profile Photo",
            message: "Take from:",
            preferredStyle: .actionSheet)
        let Camera = UIAlertAction(
            title: "Camera",
            style: .default,
            handler: {_ in
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    // use the rear camera
                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .notDetermined:
                        // we don't know
                        AVCaptureDevice.requestAccess(for: .video) {
                            accessGranted in
                            guard accessGranted == true else { return }
                        }
                    case .authorized:
                        // we have permission already
                        break
                    default:
                        // we know we don't have access
                        return
                    }
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.present(self.picker, animated: true)
                } else {
                    let alertVC = UIAlertController(
                        title: "No camera",
                        message: "Sorry, this device has no rear camera",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated:true)
                }
            }
        )
            controller.addAction(Camera)
        let Library = UIAlertAction(
            title: "Photo Library",
            style: .default,
            handler: {_ in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true)
                
            })
        controller.addAction(Library)
        present(controller, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func photoLoaded() {
        appDelegate.currentUser?.saveUser()
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        appDelegate.currentUser?.displayName = displayNameText.text!
        appDelegate.currentUser?.profilePic = profilePic.image
        uploadPhoto(image: profilePic.image as! UIImage)
        appDelegate.photoProtocol?.photoLoaded()
        let alert = UIAlertController(
            title: "Success",
            message: "Your changes are saved",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default))
        present(alert, animated: true)
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
    
    @IBAction func deleteProfilePressed(_ sender: Any) {
        // brings up an Alert where user chooses crust type from 2 buttons
        let controller = UIAlertController(
            title: "Are you sure about deleting your account?",
            message: "This action cannot be undone.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .default
        ))
        controller.addAction(UIAlertAction(
            title: "Yes",
            style: .default,
            handler: {_ in
                let user = Auth.auth().currentUser
                user?.delete { error in
                    if let error = error {
                        // An error happened.
                    } else {
                        // Account deleted.
                        do {
                            // clear this user's locations visited
                            self.clearCoreData()
                            self.db.collection("users").whereField("email", isEqualTo: appDelegate.currentUser?.userEmail).getDocuments {
                                (querySnapshot, error) in
                                if error != nil {
                                } else {
                                    for document in querySnapshot!.documents {
                                        document.reference.delete()
                                    }
                                }
                            }
                            // sign out of firebase auth
                            try Auth.auth().signOut()
                            self.dismiss(animated: true)
                        } catch {
                        }
                    }
                }
            }))
        present(controller, animated: true)
    }
    
    
    func uploadPhoto(image:UIImage){
        // This method will take the image and upload it to Firebase Storage
        let storageRef = storage.reference().child("profilePictures\(appDelegate.currentUser?.userEmail as! String).jpg")
        let resizedImage = image
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                        }
                        if let metadata = metadata {
                            appDelegate.currentUser?.profilePicturePath = "profilePictures\(appDelegate.currentUser?.userEmail as! String).jpg"
                            appDelegate.currentUser?.saveUser()
                        }
                }
        }
    }
}
