//
//  JoinController.swift
//  homePages
//
//  Created by April Zhou on 4/3/19.
//  Copyright © 2019 April Zhou. All rights reserved.
//
import UIKit

class JoinController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bracketCodeTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bracketCodeTextfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func keyboardDisable(_ sender: Any) {
        bracketCodeTextfield.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // allow backspace
        if(range.length==1 && string.count==0){
            return true
        }
        
        // allow char only
        let new = string.replacingOccurrences(of: " ", with: "")
        var old = NSString(string: textField.text ?? "")
        old = old.replacingCharacters(in: range, with: new) as NSString
        
        let number = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if old.rangeOfCharacter(from: number.inverted).location == NSNotFound {
            // allow editing
            textField.text = old as String
            DispatchQueue.main.async {
                let beginning = textField.beginningOfDocument
                let position = textField.position(from: beginning, offset: range.location + new.count)!
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            }
        }
        return false
        
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
