//
//  ConfigureGroupController.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class ConfigureGroupController: UIViewController {

    // input fields
    @IBOutlet weak var GroupNameTextField: UITextField!
    
    // delegate initialization
    weak var delegate:AddGroupDelegate?
    var seed = Int()
    
    // tournament variable for this controller
    var tournament: Tournament = Tournament()
    
    // called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates the save item button
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: .save,
                                            target: self,
                                            action: #selector(self.saveButtonPressed))
        
        // sets the save button to the top right nav bar
        self.navigationItem.rightBarButtonItem = saveItemButton
        
        //UI setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
    }
    
    @IBAction func keyboardDisable(_ sender: UITapGestureRecognizer) {
        GroupNameTextField.resignFirstResponder()
    }
    
    
    // called when the save button is pressed
    @objc func saveButtonPressed() {
        
        // adds a new group to the tournament
        self.tournament.addGroup(group: Group(name: GroupNameTextField.text!, seed: self.seed, status: true))
        
        // sends the updated tournament to the previous view
       delegate?.onGroupAdded(t: self.tournament)
        
        // returns to the previous view
       self.navigationController?.popViewController(animated: true)
    }
    
}
