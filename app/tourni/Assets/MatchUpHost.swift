//
//  MatchUpHost.swift
//  tourni
//
//  Created by Mario Taglic on 4/19/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit
import QuartzCore

class MatchUpHost: UITableViewCell {

    @IBOutlet weak var Group1Label: UILabel!
    @IBOutlet weak var Group1Button: UIButton!
    @IBOutlet weak var Group2Label: UILabel!
    @IBOutlet weak var Group2Button: UIButton!
    
    func setMatchup(g1: Group, g2: Group){
        Group1Label.text = g1.name
        Group1Label.layer.masksToBounds = true
        Group1Label.layer.cornerRadius = 8
        Group2Label.text = g2.name
        Group2Label.layer.masksToBounds = true
        Group2Label.layer.cornerRadius = 8
        Group2Button.setTitle("_", for: .normal)
        Group2Button.layer.masksToBounds = true
        Group2Button.layer.cornerRadius = 15
        Group1Button.setTitle("_", for: .normal)
        Group1Button.layer.masksToBounds = true
        Group1Button.layer.cornerRadius = 15
        
    }
    
    @IBAction func group1Win(_ sender: UIButton) {
        sender.setTitle("WIN", for: .normal)
        Group2Button.setTitle("LOSE", for: .normal)
    }
    
    @IBAction func group2Win(_ sender: UIButton) {
        sender.setTitle("WIN", for: .normal)
        Group1Button.setTitle("LOSE", for: .normal)
    }
}
