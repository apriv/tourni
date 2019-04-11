//
//  ActiveGamesController.swift
//  tourni
//
//  Created by Administrator on 4/4/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit
import Firebase

class ActiveGamesController: UITableViewController {

    // initialize a list for stored game names
    var hosted_tournament_name_list = [String]()
    
    var joined_tournament_name_list = [String]()
    
    // Initialize a list for descriptions
    var hosted_tournament_description_list = [String]()
    
    var joined_tournament_description_list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    // Set the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    // Set the number of rows for the list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return self.joined_tournament_name_list.count
        case 1:
            return self.hosted_tournament_name_list.count
        default: return 0
            
        }
    }
    
    // Set the titles of each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "Joined Events"
        case 1:
            return "Hosted Events"
        default: return "Silly devs made a coding error"
            
        }
        
    }
    
    // Set the text for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        // Set the title to the tournament name
        cell.textLabel?.text = self.hosted_tournament_name_list[indexPath.row]
        // Set the description to the tournament description
        cell.detailTextLabel?.text = self.hosted_tournament_description_list[indexPath.row]
        
        return cell
    }
    
    // function called when the user leaves the view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset list values when user leaves so the list can be updated when
        // they return.
        self.hosted_tournament_name_list = [String]()
        self.hosted_tournament_description_list = [String]()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // Create database reference for access to database
        let db = Firestore.firestore()
        
        // initialize game_code_list
        var hosted_game_code_list = [String]()
        
        // if the game code list is valid, read from it
        if UserDefaults.standard.object(forKey: "hosted_game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "hosted_game_code_list")
        }else{
            hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        }
        
        
        // get active tournament information
        // For each game code in the list of saved codes we query the database for
        // the information of that tournament
        for game_code in hosted_game_code_list{
            
            // create document that we will be querying for with one of the
            // game codes
            let docRef = db.collection("tournaments").document(game_code)
            
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                    print("Document data: \(dataDescription)")
                    
                    // get the name and description fields from the queried document
                    let name = document.get("title") as! String
                    let description = document.get("description") as! String
                    
                    // append those values to our local lists
                    self.hosted_tournament_name_list.append(name)
                    self.hosted_tournament_description_list.append(description)
                    
                    print(self.hosted_tournament_name_list)
                    
                    // update the table with our newly retrieved data
                    self.tableView.reloadData()
                    
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
