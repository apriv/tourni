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
    
    
    // Input outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var numberGroupsTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    
    // function called when view gets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.placeholder = "?"
        eventNameTextField.keyboardType = UIKeyboardType.alphabet
        numberGroupsTextField.placeholder = "8"
        numberGroupsTextField.keyboardType = UIKeyboardType.numberPad
        passwordTextField.placeholder = "****"
        passwordTextField.keyboardType = UIKeyboardType.alphabet
        descriptionTextField.placeholder = "?"
        descriptionTextField.keyboardType = UIKeyboardType.alphabet
        
    }
    
    @IBAction func keyboardDisableFunc(_ sender: Any) {
        eventNameTextField.resignFirstResponder()
        numberGroupsTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    
    // function to generate game code
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        // Get information from text input fields
        let name = eventNameTextField.text
        let num_groups = numberGroupsTextField.text
        let description = descriptionTextField.text
        
        // Create database reference for access to database
        let db = Firestore.firestore()
        
        // generate game code of length 4
        let game_code = randomString(length: 4)
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var game_code_list = defaults.object(forKey: "game_code_list") as? [String] ?? [String]()
        
        // add the game code to the list of game codes
        game_code_list.append(game_code)
        
        // store the generated game code on the user's phone
        defaults.set(game_code_list, forKey: "game_code_list")
        
        // store the new tournament to the database
        db.collection("tournaments").document(game_code).setData([
            "name": name,
            "num_groups": num_groups,
            "description" : description
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
