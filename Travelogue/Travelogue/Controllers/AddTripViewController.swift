//
//  AddTripViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/26/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {

    @IBOutlet weak var tripTitleTextField: UITextField!
    @IBOutlet weak var tripDescriptionTextBox: UITextView!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let trip = trip {
            tripTitleTextField.text = trip.title
            tripDescriptionTextBox.text = trip.contents
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveTrip(_ sender: Any) {
        guard let tripTitle = tripTitleTextField.text, let tripDescription = tripDescriptionTextBox.text else {
            print("No trip title or description set!")
            return
        }
        
        let trip = Trip(title: tripTitle, contents: tripDescription)
        
        do {
            try trip?.managedObjectContext?.save()
            
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Could not save trip")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
