//
//  AddGroupsCell.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class AddGroupsCell: UITableViewCell {
    
    // Cell data outlets
    @IBOutlet weak var GroupNameCellLabel: UILabel!
    @IBOutlet weak var SeedCellLabel: UILabel!
    
    // Sets a group to the cell
    func setGroup(group: Group){
        GroupNameCellLabel.text = group.name
        SeedCellLabel.text = String(group.seed!)
    }

}
