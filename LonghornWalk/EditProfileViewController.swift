//
//  EditProfileViewController.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/25/22.
//

import UIKit
import AVFoundation
import CoreData
import FirebaseAuth
import FirebaseCore
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    let picker = UIImagePickerController()
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var displayNameText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePic.backgroundColor = .systemGray6
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        if appDelegate.currentUser?.profilePic != nil {
            profilePic.image = appDelegate.currentUser?.profilePic
        }
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profilePic.image = appDelegate.currentUser?.profilePic
        displayNameText.text = appDelegate.currentUser?.displayName
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
//        profilePic.contentMode = .scaleAspectFit
        profilePic.image = chosenImage
        appDelegate.currentUser?.profilePic = chosenImage
        uploadPhoto(image: chosenImage)
//        let jpegImageData  = chosenImage.jpegData(compressionQuality: 1.0)
//        let entityName =  NSEntityDescription.entity(forEntityName: "CoreDataUser", in: context)!
//        let image = NSManagedObject(entity: entityName, insertInto: context)
//        image.setValue(jpegImageData, forKeyPath: "profilePic")
//        do {
//          try context.save()
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
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
        // if regular cheese option is selected, make that the cheese type of the pizza object
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
                        print("Access denied")
                        return
                    }
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.present(self.picker, animated: true)
                
                } else {
                    // no rear camera is available
                    
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
        // if no cheese option is selected, make that the cheese type of the pizza object
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
        appDelegate.currentUser?.displayName = displayNameText.text!
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        appDelegate.currentUser?.displayName = displayNameText.text!
        appDelegate.currentUser?.saveUser()
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
    
    // TODO: remove from firestore too
    @IBAction func deleteProfilePressed(_ sender: Any) {
        // brings up an Alert where user chooses crust type from 2 buttons
        let controller = UIAlertController(
            title: "Are you sure about deleting your account?",
            message: "This action cannot be undone.",
            preferredStyle: .alert)
        // if thin crust button is selected, make that the crust type of the pizza object
        // if thick crust button is selected, make that the crust type of the pizza object
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
                            // sign out of firebase auth
                            try Auth.auth().signOut()
                            self.dismiss(animated: true)
                        } catch {
                            print("Sign Out error")
                        }
                    }
                }
            }))
        present(controller, animated: true)
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: appDelegate.currentUser!.userEmail) { error in
          // ...
        }
    }
    
    func uploadPhoto(image:UIImage){
        // This method will take the image and upload it to Firebase Storage
        print("\nuploadPhoto\n")
        let storageRef = storage.reference().child("profilePictures\(appDelegate.currentUser?.userEmail as! String).jpg")
        
        let resizedImage = image
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error while uploading file: ", error)
                        }

                        if let metadata = metadata {
                            print("Metadata: ", metadata)
                            appDelegate.currentUser?.profilePicturePath = "profilePictures\(appDelegate.currentUser?.userEmail as! String).jpg"
                            print(appDelegate.currentUser?.profilePicturePath)
                            appDelegate.currentUser?.saveUser()
                        }
                }
        }
    }
    
}
