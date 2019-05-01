//
//  AddGroupsController.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class AddGroupsController: UITableViewController, UITabBarControllerDelegate {

    // Tournament variable for this view
    var tournament:Tournament = Tournament()
    
    // Initializes the seed count to one
    var seed = 1
    
    // Function called when view gets loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates the "done" button
        let doneItemButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(self.doneButtonPressed))
        
        // Sets the button to the top right bar
        self.navigationItem.rightBarButtonItem = doneItemButton
       
        // Sets the background to a gradient image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
    }
    
    
    // Called when the done button is pressed to complete
    @objc func doneButtonPressed() {
        
        // Checks if the number of groups is greater than or equal to 2
        if(tournament.getNumGroups() < 2){
            return
        }
        
        // Generates a new tournament
        self.tournament.generate()
        
        // Sends the view back a level
        self.navigationController?.popViewController(animated: true)
        
        // Sets the tab bar to the Active Games Controller
        tabBarController?.selectedIndex=0
    }
    
    
    // Called when the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournament.getNumGroups()
    }

    // Sets the group data for cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroupsCell", for: indexPath) as! AddGroupsCell
        
        // Makes cells unclickable
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.setGroup(group: self.tournament.groups![indexPath.row])

        return cell
    }
    
    // When + new group button pressed
    @IBAction func addGroup(_ sender: UIButton) {
        // Create the alert controller.
        let alert = UIAlertController(title: "Add New Group", message: "Please enter a group name", preferredStyle: .alert)
        
        // Add the text field
        alert.addTextField { (textField) in
            textField.text = ""
        }
 
        // Grab the value from the text field, and addGroup
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            // Case where the text field is empty or the group is already created with that name
            if (textField!.text == "" || self.tournament.groups!.contains(){ $0.name == textField!.text}){
                return
            }
            
            // Adds a new group to the tournament
            self.tournament.addGroup(group: Group(name: textField!.text, seed: self.seed, status: false))
            self.seed += 1
            self.tableView.reloadData()
        }))
        
        // Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    }

