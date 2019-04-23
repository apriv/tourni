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
    
    // function to get number of winners
    func getNumWinners() -> Int {
        return self.winners!.count
    }
    
    // removes group from winners and places into losers
    mutating func makeLoser(group: Group){
        
        self.winners! = winners!.filter() { $0 != group }
        
        if !(self.losers!.contains() { $0 == group}){
            self.losers!.append(group)
        }
    }
    
    // removes group from losers and places into winners
    mutating func makeWinner(group: Group){
        
        self.losers! = losers!.filter() { $0 != group }
        
        if !(self.winners!.contains() { $0 == group}){
            self.winners!.append(group)
        }
        
    }
    
    // function to set title
    mutating func setTitle(t: String){
        self.title = t
    }
    
    // function to set description
    mutating func setDescription(d: String){
        self.description = d
    }
    
    
    // function to generate game code
    func genCode(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // generate tournament, store local code and write to database (Should only be called once when tournament is created)
    mutating func generate(){
        
        let game_code = genCode(length: 4)
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        
        // add the game code to the list of game codes
        hosted_game_code_list.append(game_code)
        
        // store the generated game code on the user's phone
        defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
        
        // assign the game code to the tournament
        self.game_code = game_code
        
        
        // Checks if we need to add a free group
        let next_seed = self.groups![self.groups!.count - 1].getSeed() + 1
        while !(_isPowerOf2(self.groups!.count)){
            self.addGroup(group : Group( name: "FREE", seed: next_seed, status: false))
        }
        
        // set the winners to default = to the groups
        self.winners = self.groups;
        
        // write the tournament to the database
        self.store()
        
    }
    // Joins tournament
    static func join(game_code : String){
        
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        
        // add the game code to the list of game codes
        joined_game_code_list.append(game_code)
        
        // store the generated game code on the user's phone
        defaults.set(joined_game_code_list, forKey: "joined_game_code_list")
    }
    //deletes the tournament from the database
    func delete(){
        
        let defaults = UserDefaults.standard
        
        // retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        var joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        
        // remove the game code from the list if found
        if ( hosted_game_code_list.contains(self.game_code!)){
            
            hosted_game_code_list = hosted_game_code_list.filter() { $0 != self.game_code }
            
            // store the generated game code on the user's phone
            defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
            
            // remove tournament from database
            self.dbDelete()
            
        }else if(joined_game_code_list.contains(self.game_code!)){
            
            joined_game_code_list = joined_game_code_list.filter() { $0 != self.game_code }
            
            // store the generated game code on the user's phone
            defaults.set(joined_game_code_list, forKey: "joined_game_code_list")
            
        }
    }
 
    // Delete tournament from database
    func dbDelete(){
        
        let db = Firestore.firestore()
        
        db.collection("tournaments").document(self.game_code!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    
    
    
    // Gets the hosted tournaments and returns them in a list
    static func gethostedTournaments( completion: @escaping (_ tournament: [Tournament]) -> Void){
        
        // initialize game_code_list
        var hosted_game_code_list = [String]()
        var hosted_tournament_list = [Tournament]()
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // if the game code list is valid, read from it
        if UserDefaults.standard.object(forKey: "hosted_game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "hosted_game_code_list")
        }else{
            hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        }
        
        for game_code in hosted_game_code_list{
            Tournament.getTournament(gc: game_code){ t in
                
                if let row = hosted_tournament_list.index(where: {$0 == t}) {
                    hosted_tournament_list[row] = t
                }else{
                    hosted_tournament_list.append(t)
                }
                completion(hosted_tournament_list)
            }
            
        }
        
    }
    
    
    // Gets the joined tournaments and returns them in a list
    static func getjoinedTournaments( completion: @escaping (_ tournament: [Tournament]) -> Void){
    
        // initialize game code list
        var joined_game_code_list = [String]()
        var joined_tournament_list = [Tournament]()
        
        // create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // if the game code list is valid, read from it
        if UserDefaults.standard.object(forKey: "joined_game_code_list") == nil {
            UserDefaults.standard.setValue([String](), forKey: "joined_game_code_list")
        }else{
            joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        }
        for game_code in joined_game_code_list{
            Tournament.getTournament(gc: game_code){ t in
                if let row = joined_tournament_list.index(where: {$0 == t}) {
                    joined_tournament_list[row] = t
                }else{
                    joined_tournament_list.append(t)
                }
                completion(joined_tournament_list)
            }
        }
    }
    
    static func exists(gc: String, completion: @escaping (_ result: Bool) -> Void) {
         let db = Firestore.firestore()
        
        let docRef = db.collection("tournaments").document(gc)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
               completion(false)
            }
        }
        
    }
    
    // completion function supposed to return tournament generated from firebase
    static func getTournament(gc: String, completion: @escaping (_ tournament: Tournament) -> Void){ // gc -> game code
        
        let db = Firestore.firestore()
        
        // Get document with realtime updates
        db.collection("tournaments").document(gc)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
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
        }
    }

    
    func store() {
        
        // create list of dictionaries
        let groups_dic_list = self.groupstoDictionaryList()
        let winners_dic_list = self.winnerstoDictionaryList()
        let losers_dic_list = self.loserstoDictionaryList()
        
        
        let db = Firestore.firestore()
        
        db.collection("tournaments").document(self.game_code!).setData([
            
            "title": self.title,
            "groups": groups_dic_list,
            "description" : self.description,
            "winners" : winners_dic_list,
            "losers" : losers_dic_list
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func groupstoDictionaryList()-> [[String: AnyObject]]{
        return self.groups!.map{ $0.toDictionary()}
    }
    
    func winnerstoDictionaryList()-> [[String: AnyObject]]{
        return self.winners!.map{ $0.toDictionary()}
    }
    
    func loserstoDictionaryList()-> [[String: AnyObject]]{
        return self.losers!.map{ $0.toDictionary()}
    }
}


//Overloading for Tournament


func ==(lhs: Tournament, rhs: Tournament) -> Bool {
    return lhs.game_code == rhs.game_code
}
func !=(lhs: Tournament, rhs: Tournament) -> Bool {
    return !(lhs.game_code == rhs.game_code)
}

