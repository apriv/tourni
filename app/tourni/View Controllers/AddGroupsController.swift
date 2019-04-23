//
//  AddGroupsController.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import UIKit

class AddGroupsController: UITableViewController, AddGroupDelegate {

    // tournament variable for this view
    var tournament:Tournament = Tournament()
    var seed = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates the add item button
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(self.addButtonPressed))
        
        
        let doneItemButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(self.doneButtonPressed))
        
        // sets the button to the top right bar
        self.navigationItem.rightBarButtonItems = [doneItemButton, addItemButton]
       
        //UI setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_background")!)
    }
    
    // function called when a group is added
    func onGroupAdded(t: Tournament) {
        // updates the tournament & reloads the table
        self.tournament = t
        self.seed += 1
        self.tableView.reloadData()
    }
    
    // called when the + button is pressed to add a group. Sends the group configure view
    @objc func addButtonPressed() {
        
        self.performSegue(withIdentifier: "addGroupsToConfig", sender: self)
    }
    
    
    // called when the done button is pressed to complete
    @objc func doneButtonPressed() {
        
        self.tournament.generate()
        self.navigationController?.popViewController(animated: true)
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
        
        cell.setGroup(group: self.tournament.groups![indexPath.row])

        return cell
    }
    
    
    // sends the next view the tournament and delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ConfigureGroupController
        {
            
            let vc = segue.destination as? ConfigureGroupController
            vc?.tournament = self.tournament
            vc?.seed = self.seed
            vc?.delegate = self
        }
    }
    
    // when + new group button pressed
    @IBAction func addGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a group", message: "Please enter the group name", preferredStyle: .alert)
        
        let addBtn = UIAlertAction(title: "Add", style: .default, handler: self.addPressed)
        alert.addTextField{(groupNameTextField) ->Void in
            groupNameTextField.placeholder = "Group Name"
        }
        alert.addAction(addBtn)
        self.present(alert,animated: true,completion: nil)
    }
    
    // when Add in alert pressed
    func addPressed(alert:UIAlertAction){
        //add group
    }
}


// protocol to help us get the updated tournament from the next view
protocol AddGroupDelegate: class
{
    func onGroupAdded(t : Tournament)
}

