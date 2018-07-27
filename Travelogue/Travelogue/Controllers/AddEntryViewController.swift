//
//  AddEntryViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/26/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    @IBOutlet weak var cameraIconButton: UIButton!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryDescriptionTextBox: UITextView!
    
    var entry: Entry?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entry {
            entryTitleTextField.text = entry.title
            entryDescriptionTextBox.text = entry.contents
            entryImageView.image = entry.image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryTitle = entryTitleTextField.text, let entryContents = entryDescriptionTextBox.text,
                let entryImage = entryImageView.image else {
            return
        }
        
        let entryDate = Date()
        
        if entry == nil {
            // document doesn't exist, create new one
            if let trip = trip {
                entry = Entry(title: entryTitle, contents: entryContents, date: entryDate, image: entryImage, trip: trip)
            }
        } else {
            // document exists, update existing one
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
