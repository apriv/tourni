//
//  HostController.swift
//  tourni
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit
import Firebase

class HostController: UIViewController {
    
    var tournament = Tournament()
    
    // Input outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    
    // function called when view gets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.placeholder = "?"
        eventNameTextField.keyboardType = UIKeyboardType.alphabet
        descriptionTextField.placeholder = "?"
        descriptionTextField.keyboardType = UIKeyboardType.alphabet
        
    }
    
    @IBAction func keyboardDisableFunc(_ sender: Any) {
        eventNameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    
    // function to generate game code
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // First "Create" button
    @IBAction func createPressed(_ sender: UIButton) {
        
        // Get information from text input fields
        tournament.title = eventNameTextField.text
        tournament.description = descriptionTextField.text
    }
    
    @IBAction func addGroupButton(_ sender: Any) {
        tournament.addGroup(group: Group(name: "Test", seed: 5, status: true))
    }
    /*
    // Add group button
    @IBAction func createPressed(_ sender: UIButton) {
        
        
        // Get information from text input fields
        let name = groupNameTextField.text
        let seed = seedTextField.text
        
        tournament.addGroup(Group(name: name, seed: seed, status: bool))
        
    }
     */
     @IBAction func finishButton(_ sender: Any) {
        // generate game code of length 4
        let game_code = randomString(length: 4)
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        
        // add the game code to the list of game codes
        hosted_game_code_list.append(game_code)
        
        // store the generated game code on the user's phone
        defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
        
        // assign the game code to the tournament
        tournament.game_code = game_code
        
        // write the tournament to the database
        tournament.store()
     }
     /*
    // Final "Create" button
    @IBAction func createPressed(_ sender: UIButton) {
        
        // generate game code of length 4
        let game_code = randomString(length: 4)
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        
        // add the game code to the list of game codes
        hosted_game_code_list.append(game_code)
        
        // store the generated game code on the user's phone
        defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
        
        // assign the game code to the tournament
        tournament.game_code = game_code
        
        // write the tournament to the database
        tournament.store()
    }
    
    */
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
