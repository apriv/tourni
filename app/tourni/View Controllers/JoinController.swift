//
//  JoinController.swift
//  homePages
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit

class JoinController: UIViewController , UITabBarControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var gameCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
        
        self.gameCodeTextField.delegate = self // Ser delegate
    }

    @IBAction func joinTournamentButton(_ sender: Any) {
        if (gameCodeTextField.text != ""){
            Tournament.exists(gc: gameCodeTextField.text!){
                isThere in
                if (isThere){
                    // game code found
                    self.gameFound()
                }
                else {
                    // game code not found
                    self.gameNotFound()
                }
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countOfChars = string.characters.count +  textField.text!.characters.count - range.length
        // max char is 5
        if countOfChars > 5{
            return false
        }
        return true
    }
    
    
    // called when game code found
    func gameFound(){
        Tournament.join(game_code: self.gameCodeTextField.text!)
        
        let alert = UIAlertController(title: "Found", message: "Do you want to join ?", preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Yes", style: .default, handler: self.backToActiveGames)
        let noBtn = UIAlertAction(title: "Let me think", style: .cancel, handler: self.cleanTextfield)
        alert.addAction(yesBtn)
        //alert.addAction(noBtn)
        self.present(alert,animated: true,completion: nil)
    }
    
    // called when game code not found
    func gameNotFound(){
        let alert = UIAlertController(title: "Not Found", message: "The Game does not exist", preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Never mind", style: .default, handler: self.backToActiveGames)
        let noBtn = UIAlertAction(title: "Try again", style: .cancel, handler: self.cleanTextfield)
        alert.addAction(yesBtn)
        alert.addAction(noBtn)
        self.present(alert,animated: true,completion: nil)
    }
    
    // back to Active Games View
    func backToActiveGames(alert:UIAlertAction){
        gameCodeTextField.text = ""
        tabBarController?.selectedIndex=0
    }
    
    //to clean game code field
    func cleanTextfield(alert:UIAlertAction){
        gameCodeTextField.text = ""
    }
    
    @IBAction func keyboardDisableFunc(_ sender: UITapGestureRecognizer) {
        gameCodeTextField.resignFirstResponder()
    }
    
    
}
