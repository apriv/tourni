//
//  HostController.swift
//  tourni
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit

class HostController: UIViewController, UITextFieldDelegate {
    
    var tournament: Tournament = Tournament()
    
    // Input outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Function called when view gets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameTextField.keyboardType = UIKeyboardType.alphabet
        descriptionTextField.keyboardType = UIKeyboardType.alphabet
        
        // Sets background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
        
        // Set delegate
        self.eventNameTextField.delegate = self
        self.descriptionTextField.delegate = self
    }
    
    // Textfield constrain
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countOfChars = string.characters.count +  textField.text!.characters.count - range.length
        // Max char 20
        if countOfChars > 20{
            return false
        }
        return true
    }
    
    // Called when "Create" button is pressed
    @IBAction func createButtonPressed(_ sender: Any) {
        
        // Checks for empty strings
        if (eventNameTextField.text! == "" || descriptionTextField.text! == ""){
            return
        }
        
        // Sets the title and description from the inputted text
        self.tournament.setTitle(t: eventNameTextField.text!)
        self.tournament.setDescription(d: descriptionTextField.text!)
        
        // Moves to next screen
        self.performSegue(withIdentifier: "hostToAddGroupsSegue", sender: self)
    }
    
    // Removes keyboard onlick
    @IBAction func keyboardDisable(_ sender: UITapGestureRecognizer) {
        eventNameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    
    // Passes the semi-created tournament to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is AddGroupsController
        {
            let vc = segue.destination as? AddGroupsController
            vc?.tournament = self.tournament
        }
    }
    
}
