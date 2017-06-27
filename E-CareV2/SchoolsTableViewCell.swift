//
//  SchoolsTableViewCell.swift
//  E-CareV2
//
//  Created by Nupur Sharma on 16/06/17.
//  Copyright © 2017 Franciscan. All rights reserved.
//

import UIKit

class SchoolsTableViewCell: UITableViewCell {

    @IBOutlet var schoolImg: UIImageView!
    @IBOutlet var schoolName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
