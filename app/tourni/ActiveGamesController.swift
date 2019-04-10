//
//  ActiveGamesController.swift
//  tourni
//
//  Created by Administrator on 4/4/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit
import Firebase

class ActiveGamesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // Create database reference for access to database
        let db = Firestore.firestore()
        
        // initialize game_code_list
        var game_code_list = [String]()
        
        // retrieve the stored list from the phone
        if UserDefaults.standard.object(forKey: "game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "game_code_list")
        }else{
            game_code_list = defaults.object(forKey: "game_code_list") as? [String] ?? [String]()
        }
        
        // initialize a list for stored game names
        var game_name_list = [String]()
        
        // get active tournament information
        for game_code in game_code_list{
            
            let docRef = db.collection("tournaments").document(game_code)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let name = document.get("name") as! String
                    game_name_list.append(name)
                    print(game_name_list)
                } else {
                    print("Document does not exist")
                }
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
