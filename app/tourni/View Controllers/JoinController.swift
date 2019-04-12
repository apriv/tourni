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
    }
    
    
    @IBAction func keyboardDisableFunc(_ sender: UITapGestureRecognizer) {
        gameCodeTextField.resignFirstResponder()
    }
    
    
}
