//
//  EditProfileViewController.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/25/22.
//

import UIKit
import AVFoundation
import CoreData


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var selectedImage: UIImage!

    let picker = UIImagePickerController()
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var displayNameText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        displayNameText.text = appDelegate.currentUser?.displayName
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
//        profilePic.contentMode = .scaleAspectFit
        profilePic.image = chosenImage
        EditProfileViewController.selectedImage = chosenImage
        appDelegate.currentUser?.profilePic = chosenImage
        let jpegImageData  = chosenImage.jpegData(compressionQuality: 1.0)
        let entityName =  NSEntityDescription.entity(forEntityName: "CoreDataUser", in: context)!
        let image = NSManagedObject(entity: entityName, insertInto: context)
        image.setValue(jpegImageData, forKeyPath: "profilePic")
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
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
        if displayNameText.text != "" {
            appDelegate.currentUser?.displayName = displayNameText.text!
        }
    }
    
    
    @IBAction func deleteProfilePressed(_ sender: Any) {
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
    }
    
}