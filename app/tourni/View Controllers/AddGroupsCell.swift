//
//  AddGroupsCell.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class AddGroupsCell: UITableViewCell {

    @IBOutlet weak var GroupNameCellLabel: UILabel!
    @IBOutlet weak var SeedCellLabel: UILabel!
    
    func setGroup(group: Group){
        GroupNameCellLabel.text = group.name
        SeedCellLabel.text = String(group.seed)
    }

}
