//
//  EntryViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/27/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryDescriptionLabel: UILabel!
    
    var trip: Trip?
    var entry: Entry?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Here!")

        if let entry = entry {
            print("Here in entry")
            entryImageView.image = entry.image
            entryTitleLabel.text = entry.title
            entryDescriptionLabel.text = entry.contents
            
            self.title = entry.title
            
            if let date = entry.date {
                dateFormatter.dateFormat = "MMM d, yyyy"
                entryDateLabel.text = dateFormatter.string(from: date)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
