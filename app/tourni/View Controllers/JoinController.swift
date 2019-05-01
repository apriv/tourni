//
//  JoinController.swift
//  homePages
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit

class JoinController: UIViewController , UITabBarControllerDelegate, UITextFieldDelegate{
    
    // Outlet for game code
    @IBOutlet weak var gameCodeTextField: UITextField!
    
    // Function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
        
        // Set delegate
        self.gameCodeTextField.delegate = self
    }

    // Called when "Join" button is pressed
    @IBAction func joinTournamentButton(_ sender: Any) {
        if (gameCodeTextField.text != ""){
            Tournament.exists(gc: gameCodeTextField.text!){
                isThere in
                if (isThere){
                    // Game code found
                    self.gameFound()
                }
                else {
                    // Game code not found
                    self.gameNotFound()
                }
            }
        }
        
    }
    
    // Constraints for game code text-field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countOfChars = string.characters.count +  textField.text!.characters.count - range.length
        // max char is 5
        if countOfChars > 5{
            return false
        }
        return true
    }
    
    
    // Called when game code found
    func gameFound(){
        Tournament.join(game_code: self.gameCodeTextField.text!)
        
        let alert = UIAlertController(title: "Found", message: "Do you want to join?", preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Yes", style: .default, handler: self.backToActiveGames)
        let noBtn = UIAlertAction(title: "Let me think", style: .cancel, handler: self.cleanTextfield)
        alert.addAction(yesBtn)
        //alert.addAction(noBtn)
        self.present(alert,animated: true,completion: nil)
    }
    
    // Called when game code not found
    func gameNotFound(){
        let alert = UIAlertController(title: "Not Found", message: "Game code not found", preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Never mind", style: .default, handler: self.backToActiveGames)
        let noBtn = UIAlertAction(title: "Try again", style: .cancel, handler: self.cleanTextfield)
        //alert.addAction(yesBtn)
        alert.addAction(noBtn)
        self.present(alert,animated: true,completion: nil)
    }
    
    // Back to Active Games View
    func backToActiveGames(alert:UIAlertAction){
        gameCodeTextField.text = ""
        tabBarController?.selectedIndex=0
    }
    
    // To clean game code field
    func cleanTextfield(alert:UIAlertAction){
        gameCodeTextField.text = ""
    }
    
    // Removes keyboard on click
    @IBAction func keyboardDisableFunc(_ sender: UITapGestureRecognizer) {
        gameCodeTextField.resignFirstResponder()
    }
    
    
}
