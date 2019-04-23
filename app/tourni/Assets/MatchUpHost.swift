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
    
    @IBOutlet weak var winnerIcon1: UIImageView!
    @IBOutlet weak var winnerIcon2: UIImageView!
    
    
    
    var group1 = Group()
    var group2 = Group()
    
    // delegate initialization
    weak var delegate:cellInfo?
    
    var winnerSelected: Bool = false
    
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
        self.group1 = g1
        self.group2 = g2
    }
    
    @IBAction func group1ButtonAction(_ sender: Any) {
        
        if !((delegate?.isHost())!){
            return
        }
        
        winnerIcon1.isHidden = false
        winnerIcon2.isHidden = true
        
        
        // if the winner is not already selected increment the winner selected count in bracket controller
        if !(winnerSelected){
            
            delegate?.incrementWinnerSelectedCount()
            
            winnerSelected = true
        }
        
        // sends the winner/loser choice to the bracketController
        delegate?.updateWinner(winner: self.group1, loser: self.group2)
        
    }
    
    @IBAction func group2ButtonAction(_ sender: Any) {
        
        if !((delegate?.isHost())!){
            return
        }
        
        if (group2.name == "FREE"){
            return
        }
        
        winnerIcon2.isHidden = false
        winnerIcon1.isHidden = true
        
        // if the winner is not already selected increment the winner selected count in
        if !(winnerSelected){
            
            delegate?.incrementWinnerSelectedCount()
            
            winnerSelected = true
        }
        
        // sends the winner/loser choice to the bracketController
        delegate?.updateWinner(winner: self.group2, loser: self.group1)
    }
    
}


