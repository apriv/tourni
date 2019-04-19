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
    
    func setMatchup(g1: Group, g2: Group){
        Group1Label.text = g1.name
        Group2Label.text = g2.name
        Group2Button.setTitle("_", for: .normal)
        Group1Button.setTitle("_", for: .normal)
        
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
