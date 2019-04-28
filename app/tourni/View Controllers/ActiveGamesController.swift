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

    // Initialize a list for hosted tournaments
    var hosted_tournament_list = [Tournament]()
    
    // Initialize a list for join tournaments
    var joined_tournament_list = [Tournament]()
    
    // Intilaize the selected tournament
    var selected_tournament = Tournament()

    // Stores value of whether or not you are the host of the selected tournament
    var host = false
    
    // ViewDidLoad Function (the functions that are called when the view is loaded)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Background UIColor
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
        
    }
    
    // Called when displaying table
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            
            // Sets the color of section header background and text
            headerView.contentView.backgroundColor = UIColor(red:0.96, green:0.65, blue:0.76, alpha:1.0)
            headerView.textLabel?.textColor = .white
            
        }
    }
    
    // Called when a tournament gets selected from the list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section){
            case 0:
                
                // Set the selected tournament as the selected
                selected_tournament = joined_tournament_list[indexPath.row]
                
                // Segue to the bracket
                self.performSegue(withIdentifier: "toBracket", sender: self)
                
                break;
            
            case 1:
                
                // Set the selected tournament as the selected
                selected_tournament = hosted_tournament_list[indexPath.row]
                
                // Indicate that a hosted tournament was selected
                self.host = true
                
                // Segue to the bracket
                self.performSegue(withIdentifier: "toBracket", sender: self)
                
                break;
            
            default:
                break;
        }
        
    }
    
    // Called when a segue to the bracket is initiated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BracketController
        {
            let vc = segue.destination as? BracketController
            
            // Sets the game code for the bracket view
            vc?.game_code = self.selected_tournament.game_code!
            
            // Sets the host value for the bracket view
            vc?.host = self.host
            
            // Sets the tournament title for the bracket view
            vc?.navigationItem.title = self.selected_tournament.title
        }
    }
    
    
    // Set the text for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveGamesCell", for: indexPath) as! ActiveGamesCell
        
        switch(indexPath.section){
            case 0:
                // Set the cell to the tournament
                cell.setTournament(tournament: joined_tournament_list[indexPath.row])
                break;
            case 1:
                // Set the cell to the tournament
                cell.setTournament(tournament: hosted_tournament_list[indexPath.row])
                break;
            default:
                break;
        
        }
        return cell
    }
    
    // Delete from the table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // delete selected tournament
            switch(indexPath.section){
                case 0:
                    
                    joined_tournament_list[indexPath.row].delete()
                    joined_tournament_list.remove(at: indexPath.row)
                    break;
                
                case 1:
                    
                    hosted_tournament_list[indexPath.row].delete()
                    hosted_tournament_list.remove(at: indexPath.row)
                    break;
                
                default:
                    break;
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    
    // Function called when the user leaves the view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Resets the host flag
        self.host = false
        
        // Reset list values when user leaves so the list can be updated when
        // they return.
        hosted_tournament_list = [Tournament]()
        joined_tournament_list = [Tournament]()
    }
    
    
    
    
    // Function called when the view appears on screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Forces the tab bar to appear
         self.tabBarController!.tabBar.isHidden = false
        
        // Fompletion calls to generate the list of joined and hosted tournaments
        Tournament.gethostedTournaments(){ t_list in
            self.hosted_tournament_list = t_list
            self.tableView.reloadData()
        }
        
        Tournament.getjoinedTournaments(){ t_list in
            self.joined_tournament_list = t_list
            self.tableView.reloadData()
        }
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
            return "Joined Tournaments"
        case 1:
            return "Hosted Tournaments"
        default: return "Silly devs made a coding error"
            
        }
        
    }


}

