//
//  AddEntryViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/26/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraIconButton: UIButton!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryDescriptionTextBox: UITextView!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    var entry: Entry?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entry {
            entryTitleTextField.text = entry.title
            entryDescriptionTextBox.text = entry.contents
            entryImageView.image = entry.image
            
            self.title = entry.title
            
            handleButtonAppearance(cameraIconEnabled: false, deleteIconEnabled: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Show/hide the camera and delete icons
    func handleButtonAppearance(cameraIconEnabled: Bool, deleteIconEnabled: Bool) {
        _ = cameraIconEnabled ? (cameraIconButton.isEnabled = true, cameraIconButton.isHidden = false) : (cameraIconButton.isEnabled = false, cameraIconButton.isHidden = true)
        
        _ = deleteIconEnabled ? (deleteImageButton.isEnabled = true, deleteImageButton.isHidden = false) : (deleteImageButton.isEnabled = false, deleteImageButton.isHidden = true)
    }
    
    // Add Image
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image Options", message: "Use your camera or access your photo library?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    //Remove Image
    @IBAction func removeImage(_ sender: Any) {
        entryImageView.image = nil
        
        handleButtonAppearance(cameraIconEnabled: true, deleteIconEnabled: false)
    }
    
    //Image Picker Controller.. Handles what to do with the picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        entryImageView.image = image
        
        handleButtonAppearance(cameraIconEnabled: false, deleteIconEnabled: true)

        dismiss(animated: true)
    }
    
    //Save the Entry into CoreData
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryTitle = entryTitleTextField.text, let entryContents = entryDescriptionTextBox.text, let entryImage = entryImageView.image,
        !entryTitle.isEmpty, !entryContents.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "You must include a title and description!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let entryDate = Date()
                
        if entry == nil {
            if let trip = trip {
                entry = Entry(title: entryTitle, contents: entryContents, date: entryDate, image: entryImage, trip: trip)
            }
        } else {
            if let trip = trip {
                entry?.update(title: entryTitle, contents: entryContents, date: entryDate, image: entryImage, trip: trip)
            }
        }
        
        if let entry = entry {
            do {
                let managedContext = entry.managedObjectContext
                try managedContext?.save()
            } catch {
                print("Enty not saved!")
            }
        } else {
            print("Entry entity could not be created!")
        }
        
        navigationController?.popViewController(animated: true)
    }

}
