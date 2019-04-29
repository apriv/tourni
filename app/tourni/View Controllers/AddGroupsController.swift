//
//  AddGroupsController.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class AddGroupsController: UITableViewController, UITabBarControllerDelegate {

    // tournament variable for this view
    var tournament:Tournament = Tournament()
    var seed = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let doneItemButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(self.doneButtonPressed))
        
        // sets the button to the top right bar
        self.navigationItem.rightBarButtonItem = doneItemButton
       
        //BG setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
    }
    
    
    // called when the + button is pressed to add a group. Sends the group configure view
    @objc func addButtonPressed() {
        
        self.performSegue(withIdentifier: "addGroupsToConfig", sender: self)
    }
    
    
    // called when the done button is pressed to complete
    @objc func doneButtonPressed() {
        if(tournament.getNumGroups() < 2){
            return
        }
        self.tournament.generate()
        self.navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex=0
    }
    
    
    // called when the view appears
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

    // sets the group data for cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroupsCell", for: indexPath) as! AddGroupsCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.setGroup(group: self.tournament.groups![indexPath.row])

        return cell
    }
    
    // when + new group button pressed
    @IBAction func addGroup(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add New Group", message: "Please enter a group name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
 
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            // Case where the text field is empty or the group is already created with that name
            if (textField!.text == "" || self.tournament.groups!.contains(){ $0.name == textField!.text}){
                return
            }
            
            // adds a new group to the tournament
            self.tournament.addGroup(group: Group(name: textField!.text, seed: self.seed, status: false))
            self.seed += 1
            self.tableView.reloadData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    }

