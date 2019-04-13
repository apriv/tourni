//
//  ActiveGamesCell.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class ActiveGamesCell: UITableViewCell {
    
    @IBOutlet weak var ActiveGamesTitleLabel: UILabel!
    @IBOutlet weak var ActiveGamesDescriptionLabel: UILabel!
    
    func setTournament(tournament: Tournament){
        ActiveGamesTitleLabel.text = tournament.title
        ActiveGamesDescriptionLabel.text = tournament.description
    }
 
}
