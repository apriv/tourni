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

    // Outlets for Labels, Buttons, and Ribbons.
    @IBOutlet weak var Group1Label: UILabel!
    @IBOutlet weak var Group1Button: UIButton!
    @IBOutlet weak var Group2Label: UILabel!
    @IBOutlet weak var Group2Button: UIButton!
    
    @IBOutlet weak var winnerIcon1: UIImageView!
    @IBOutlet weak var winnerIcon2: UIImageView!
    
    // Initializes two groups for the MatchUp.
    var group1 = Group()
    var group2 = Group()
    
    // Delegate initialization.
    weak var delegate:cellInfo?
    
    // Initializes boolean for a winner selected.
    var winnerSelected: Bool = false
    
    // Initializes round to zero.
    var round: Int = 0
    
    // Function to set the groups and round number of the MatchUp.
    func setMatchup(g1: Group, g2: Group, round: Int){
        
        // Sets the text for group 1 & rounds corners.
        Group1Label.text = g1.name
        Group1Label.layer.masksToBounds = true
        Group1Label.layer.cornerRadius = 8
        
        // Sets the text for group 2 & rounds corners.
        Group2Label.text = g2.name
        Group2Label.layer.masksToBounds = true
        Group2Label.layer.cornerRadius = 8
        
        // Rounds corners
        Group2Button.layer.masksToBounds = true
        Group2Button.layer.cornerRadius = 15
        
        Group1Button.layer.masksToBounds = true
        Group1Button.layer.cornerRadius = 15
        
        // Sets groups for this MatchUp.
        self.group1 = g1
        self.group2 = g2
        
        // Sets round for this MatchUp.
        self.round = round
        
        // Hides buttons if the status of group is false.
        if group1.status{
            winnerIcon1.isHidden = false
        }else{
            winnerIcon1.isHidden = true
        }
        
        if group2.status{
            winnerIcon2.isHidden = false
        }else{
            winnerIcon2.isHidden = true
        }
        
        // If both groups' statuses are false indicate that the winner has not been selected.
        if !(group1.status || group2.status){
            winnerSelected = false
        }
    }
    
    // Function called when group 1 is selected
    @IBAction func group1ButtonAction(_ sender: Any) {
        
        // If the user is not the host of this tournament or it is a previous round, return from button action.
        if !((delegate?.isHost())!) || self.round != delegate?.getCurrentRound(){
            return
        }
        
        // Display the ribbon for group 1 and hide group 2
        winnerIcon1.isHidden = false
        winnerIcon2.isHidden = true
        
        
        // If the winner is not already selected increment the winner selected count in bracket controller
        if !(winnerSelected){
            
            delegate?.incrementWinnerSelectedCount()
            
            winnerSelected = true
        }
        
        // Sends the winner/loser choice to the bracketController
        delegate?.updateWinner(winner: self.group1, loser: self.group2, round: self.round)
        
    }
    
    // Function called when group 2 is selected
    @IBAction func group2ButtonAction(_ sender: Any) {
        
        // If the user is not the host of this tournament or it is a previous round, return from button action.
        if !((delegate?.isHost())!) || self.round != delegate?.getCurrentRound() || group2.name == "FREE"{
            return
        }
        
        // Display the ribbon for group 2 and hide group 1
        winnerIcon2.isHidden = false
        winnerIcon1.isHidden = true
        
        // If the winner is not already selected increment the winner selected count in
        if !(winnerSelected){
            
            delegate?.incrementWinnerSelectedCount()
            
            winnerSelected = true
        }
        
        // Sends the winner/loser choice to the bracketController
        delegate?.updateWinner(winner: self.group2, loser: self.group1, round: self.round)
    }
    
    
}


