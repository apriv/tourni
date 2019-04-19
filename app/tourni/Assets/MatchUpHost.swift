//
//  MatchUpHost.swift
//  tourni
//
//  Created by Mario Taglic on 4/19/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class MatchUpHost: UITableViewCell {

    @IBOutlet weak var Group1Label: UILabel!
    @IBOutlet weak var Group1Button: UIButton!
    @IBOutlet weak var Group2Label: UILabel!
    @IBOutlet weak var Group2Button: UIButton!
    
    
    @IBAction func ChangeTeam1Status(_ sender: UIButton) {
        //When click on the button, the title on Team2Button changes from "WIN" to "LOSE"
        
        
    }
    
    func setMatchup(g1: Group, g2: Group){
        Group1Label.text = g1.name
        Group2Label.text = g2.name
    }

}
