//
//  Tournament.swift
//  tourni
//
//  Created by Administrator on 4/10/19.
//  Copyright © 2019 group13. All rights reserved.
//
import Firebase
import Foundation

struct Tournament {
    var title:String?
    var groups:[Group]?
    var description:String?
    var game_code:String?
    var winners:[Group]?
    var losers:[Group]?
    
    init(
        title: String? = nil,
        groups: [Group]? = [Group](),
        description: String? = nil,
        game_code: String? = nil,
        winners: [Group]? = [Group](),
        losers: [Group]? = [Group]()) {
        
        self.title = title
        self.groups = groups
        self.description = description
        self.game_code = game_code
        self.winners = winners
        self.losers = losers
    }
    
    // function to get the number of groups
    func getNumGroups() -> Int{
        return self.groups!.count
    }
    
    // function to add group to tournament
    mutating func addGroup(group: Group){
        self.groups!.append(group)
    }
    
    // completion function supposed to return tournament generated from firebase
    static func getTournament(gc: String, completion: @escaping (_ tournament: Tournament) -> Void){ // gc -> game code
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("tournaments").document(gc)
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("Document data: \(dataDescription)")
                
                // get the name and description fields from the queried document
                let name = document.get("title") as! String
                let description = document.get("description") as! String
                let groups_map_list = document.get("groups") as! [[String: AnyObject]]
                let winners_map_list = document.get("winners") as! [[String: AnyObject]]
                let losers_map_list = document.get("losers") as! [[String: AnyObject]]
                
                var tournament = Tournament( title: name, description: description, game_code: gc)
                
                for dictionary in groups_map_list{
                    
                    let g = Group( name: dictionary["name"] as! String, seed: dictionary["seed"] as! Int, status: dictionary["status"] as! Bool)
                    
                    tournament.groups!.append(g)
                    
                }
                
                for dictionary in winners_map_list{
                    
                    let g = Group( name: dictionary["name"] as! String, seed: dictionary["seed"] as! Int, status: dictionary["status"] as! Bool)
                    
                    tournament.winners!.append(g)
                    
                }
                
                for dictionary in losers_map_list{
                    
                    let g = Group( name: dictionary["name"] as! String, seed: dictionary["seed"] as! Int, status: dictionary["status"] as! Bool)
                    
                    tournament.losers!.append(g)
                    
                }
                
                completion(tournament)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func store() {
        
        // create list of dictionaries
        var groups_map_list = [[String: AnyObject]]()
        var winners_map_list = [[String: AnyObject]]()
        var losers_map_list = [[String: AnyObject]]()
        
        for g in self.groups!{
            
            groups_map_list.append(["name": g.name as AnyObject, "seed": g.seed as AnyObject, "status": g.status as AnyObject])
            
        }
        
        for g in self.winners!{
            
            winners_map_list.append(["name": g.name as AnyObject, "seed": g.seed as AnyObject, "status": g.status as AnyObject])
            
        }
        
        for g in self.losers!{
            
            losers_map_list.append(["name": g.name as AnyObject, "seed": g.seed as AnyObject, "status": g.status as AnyObject])
            
        }
        
        
        let db = Firestore.firestore()
        
        db.collection("tournaments").document(self.game_code!).setData([
            
            "title": self.title,
            "groups": groups_map_list,
            "description" : self.description,
            "winners" : self.winners,
            "losers" : self.losers
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
}
