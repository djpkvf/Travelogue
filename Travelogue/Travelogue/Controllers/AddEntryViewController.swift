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
            
            cameraIconButton.isEnabled = true
            cameraIconButton.isHidden = false
            
            deleteImageButton.isEnabled = true
            deleteImageButton.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func removeImage(_ sender: Any) {
        entryImageView.image = nil
        
        cameraIconButton.isEnabled = true
        cameraIconButton.isHidden = false
        
        deleteImageButton.isEnabled = false
        deleteImageButton.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        entryImageView.image = image
        cameraIconButton.isEnabled = false
        cameraIconButton.isHidden = true
        
        deleteImageButton.isEnabled = true
        deleteImageButton.isHidden = false

        dismiss(animated: true)
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryTitle = entryTitleTextField.text, let entryContents = entryDescriptionTextBox.text, let entryImage = entryImageView.image else {
            // If information is missing present the user with an error message
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
