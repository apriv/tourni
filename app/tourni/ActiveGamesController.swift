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

    // initialize a list for hosted tournaments
    var hosted_tournament_list = [Tournament]()
    
    var joined_tournament_list = [Tournament]()
    
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
            return joined_tournament_list.count
        case 1:
            return hosted_tournament_list.count
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
        
        // Possible code for empty case
        /*
        if (IndexPath.isEmpty()){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) // Needs different identifier "LabelCell" is not what we want
            
            cell.textLabel?.text = "No active tournaments"
            
            return cell
        }
        */
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        // Set the title to the tournament name
        cell.textLabel?.text = hosted_tournament_list[indexPath.row].title
        // Set the description to the tournament description
        cell.detailTextLabel?.text = hosted_tournament_list[indexPath.row].description
        
        
        return cell
    }
    
    // function called when the user leaves the view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset list values when user leaves so the list can be updated when
        // they return.
        hosted_tournament_list = [Tournament]()
        joined_tournament_list = [Tournament]()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ////////////////Get stored list of game codes/////////////////////////
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // initialize game_code_list
        var hosted_game_code_list = [String]()
        var joined_game_code_list = [String]()
        
        // if the game code list is valid, read from it
        if UserDefaults.standard.object(forKey: "hosted_game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "hosted_game_code_list")
        }else{
            hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        }
        
        // if the game code list is valid, read from it
        if UserDefaults.standard.object(forKey: "joined_game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "joined_game_code_list")
        }else{
            joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        }
        
        ///////////////////Get tournaments asociated with those codes/////////////////////////
        
        // get active hosted tournament information
        // For each game code in the list of saved codes we get the tournament associated with that code
        for game_code in hosted_game_code_list{
            Tournament.getTournament(gc: game_code){ t in
                self.hosted_tournament_list.append(t)
                self.tableView.reloadData()
            }
        }
        
        // get active joined tournament information
        // For each game code in the list of saved codes we get the tournament associated with that code
        for game_code in joined_game_code_list{
            Tournament.getTournament(gc: game_code){ t in
                self.joined_tournament_list.append(t)
                self.tableView.reloadData()
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
