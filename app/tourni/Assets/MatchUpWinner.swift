//
//  MatchUpWinner.swift
//  tourni
//
//  Created by Shun Zhang on 4/22/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit
import QuartzCore

class MatchUpWinner: UITableViewCell {
    
    @IBOutlet weak var WinnerLabel: UILabel!
    @IBOutlet weak var Medal: UIImageView!
    
    func setWinner(winner: Group){
        
    WinnerLabel.layer.masksToBounds = true
    WinnerLabel.layer.cornerRadius = 8
    }
}
