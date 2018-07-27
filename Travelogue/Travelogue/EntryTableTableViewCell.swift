//
//  EntryTableTableViewCell.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/26/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class EntryTableTableViewCell: UITableViewCell {

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
