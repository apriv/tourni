//
//  JoinController.swift
//  homePages
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit

class JoinController: UIViewController {
    
    @IBOutlet weak var gameCodeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //UI setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
    }

    @IBAction func joinTournamentButton(_ sender: Any) {
        Tournament.join(game_code: gameCodeTextField.text!)
    }
    
    @IBAction func keyboardDisableFunc(_ sender: UITapGestureRecognizer) {
        gameCodeTextField.resignFirstResponder()
    }
    
    
}
