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
    
    // function called when view gets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameTextField.keyboardType = UIKeyboardType.alphabet
        descriptionTextField.keyboardType = UIKeyboardType.alphabet
        
        //backgrounf img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
        
        self.eventNameTextField.delegate = self // set delegate
    }
    
    // textfield constrain
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countOfChars = string.characters.count +  textField.text!.characters.count - range.length
        // max char 20
        if countOfChars > 20{
            return false
        }
        return true
    }
    

    @IBAction func createButtonPressed(_ sender: Any) {
        // sets the title and description from the inputted text
        self.tournament.setTitle(t: eventNameTextField.text!)
        self.tournament.setDescription(d: descriptionTextField.text!)
        
        // moves to next screen
        self.performSegue(withIdentifier: "hostToAddGroupsSegue", sender: self)
    }
    
    @IBAction func keyboardDisable(_ sender: UITapGestureRecognizer) {
        eventNameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    
    // passes the semi-created tournament to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is AddGroupsController
        {
            let vc = segue.destination as? AddGroupsController
            vc?.tournament = self.tournament
        }
    }
    
}
