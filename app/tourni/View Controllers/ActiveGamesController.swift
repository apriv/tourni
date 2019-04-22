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
    
    // initialize a list for join tournaments
    var joined_tournament_list = [Tournament]()
    
    // intilaize the selected tournament
    var selected_tournament = Tournament()
    
    //viewDidLoad Function (the functions that are called when the view is loaded)
    override func viewDidLoad() {
        super.viewDidLoad()
        //background UIColor
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section){
            case 0:
                // Set the selected tournament as the selected
                selected_tournament = joined_tournament_list[indexPath.row]
                // segue to the bracket
                self.performSegue(withIdentifier: "toBracket", sender: self)
                break;
            
            case 1:
                // Set the selected tournament as the selected
                selected_tournament = hosted_tournament_list[indexPath.row]
                
                // segue to the bracket
                self.performSegue(withIdentifier: "toBracket", sender: self)
                break;
            default:
                break;
        }
        
    }
    
    // passes the tournament to the bracket controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BracketController
        {
            let vc = segue.destination as? BracketController
            vc?.game_code = self.selected_tournament.game_code!
        }
    }
    
    
    // set the text for each cell
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
    
    // delete from the table
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
    
    
    
    // function called when the user leaves the view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset list values when user leaves so the list can be updated when
        // they return.
        hosted_tournament_list = [Tournament]()
        joined_tournament_list = [Tournament]()
    }
    
    
    
    
    // function called when the view appears on screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            return "Joined Events"
        case 1:
            return "Hosted Events"
        default: return "Silly devs made a coding error"
            
        }
        
    }


}
