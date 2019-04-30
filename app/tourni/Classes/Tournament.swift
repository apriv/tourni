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
    
    // Title of the tournament
    var title:String?
    
    // List of groups in the tournament
    var groups:[Group]?
    
    // Description of the tournament
    var description:String?
    
    // Unique game code for tournament
    var game_code:String?
    
    // List of current winners in the tournament
    var winners:[Group]?
    
    // List of current losers in the tournament
    var losers:[Group]?
    
    // List of Group lists corresponding to each round
    var roundList:[[Group]]?
    
    // Initializer
    init(
        title: String? = nil,
        groups: [Group]? = [Group](),
        description: String? = nil,
        game_code: String? = nil,
        winners: [Group]? = [Group](),
        losers: [Group]? = [Group](),
        roundList:[[Group]]? = [[Group]]()){
        
        self.title = title
        self.groups = groups
        self.description = description
        self.game_code = game_code
        self.winners = winners
        self.losers = losers
        self.roundList = roundList
    }
    
    // Function to get the number of groups
    func getNumGroups() -> Int{
        return self.groups!.count
    }
    
    // Function to add group to tournament
    mutating func addGroup(group: Group){
        self.groups!.append(group)
    }
    
    // Function to get number of winners
    func getNumWinners() -> Int {
        return self.winners!.count
    }
    
    // Removes group from winners and places into losers
    mutating func makeLoser(group: Group){
        
        self.winners! = winners!.filter() { $0 != group }
        
        if !(self.losers!.contains() { $0 == group}){
            self.losers!.append(group)
        }
    }
    
    // Removes group from losers and places into winners
    mutating func makeWinner(group: Group){
        
        self.losers! = losers!.filter() { $0 != group }
        
        if !(self.winners!.contains() { $0 == group}){
            self.winners!.append(group)
        }
        
    }
    
    // Function to set title
    mutating func setTitle(t: String){
        self.title = t
    }
    
    // Function to set description
    mutating func setDescription(d: String){
        self.description = d
    }
    
    
    // Function to generate game code
    func genCode(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // Generate tournament, store local code and write to database (Should only be called once when tournament is created)
    mutating func generate(){
        
        let game_code = genCode(length: 4)
        
        // Create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // Retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        
        // Add the game code to the list of game codes
        hosted_game_code_list.append(game_code)
        
        // Store the generated game code on the user's phone
        defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
        
        // Assign the game code to the tournament
        self.game_code = game_code
        
        
        // Checks if we need to add a free group
        let next_seed = self.groups![self.groups!.count - 1].getSeed() + 1
        while !(_isPowerOf2(self.groups!.count)){
            self.addGroup(group : Group( name: "FREE", seed: next_seed, status: false))
        }
        
        // Set the winners to default = to the groups
        self.winners = self.groups
        
        self.roundList!.append(self.groups!)
        
        // Write the tournament to the database
        self.store()
        
    }
    
    // Joins tournament
    static func join(game_code : String){
        
        let defaults = UserDefaults.standard
        
        // Retrieve the stored list from the phone
        var joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        
        // Add the game code to the list of game codes
        joined_game_code_list.append(game_code)
        
        // Store the generated game code on the user's phone
        defaults.set(joined_game_code_list, forKey: "joined_game_code_list")
    }
    
    // Deletes hosted tournament
    func deleteHosted(){
        
        let defaults = UserDefaults.standard
        
        // Retrieve the stored list from the phone
        var hosted_game_code_list = defaults.object(forKey: "hosted_game_code_list") as? [String] ?? [String]()
        
        // Remove the game code from the list if found
        if (hosted_game_code_list.contains(self.game_code!)){
            
            hosted_game_code_list = hosted_game_code_list.filter() { $0 != self.game_code }
            
            // Store the generated game code on the user's phone
            defaults.set(hosted_game_code_list, forKey: "hosted_game_code_list")
            
            // Remove tournament from database
            self.dbDelete()
            
        }
    }
    
    // Deletes joined tournament
    func deleteJoined(){
        
        let defaults = UserDefaults.standard
        
        // Retrieve the stored list from the phone
        var joined_game_code_list = defaults.object(forKey: "joined_game_code_list") as? [String] ?? [String]()
        
        // Remove the game code from the list if found
        if(joined_game_code_list.contains(self.game_code!)){
            
            joined_game_code_list = joined_game_code_list.filter() { $0 != self.game_code }
            
            // Store the generated game code on the user's phone
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
        
        // Initialize game_code_list
        var hosted_game_code_list = [String]()
        var hosted_tournament_list = [Tournament]()
        
        // Create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // If the game code list is valid, read from it
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
    
        // Initialize game code list
        var joined_game_code_list = [String]()
        var joined_tournament_list = [Tournament]()
        
        // Create reference to "user defaults" -> (data stored on phone)
        let defaults = UserDefaults.standard
        
        // If the game code list is valid, read from it
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
    
    // Checks if a tournament with the inputted game code is in the database
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
    
    // Gets tournament with inputted game code from the database and returns it.
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
                    
                    return
                }
                
                // get the name and description fields from the queried document
                let name = document.get("title") as! String
                let description = document.get("description") as! String
                let groups_map_list = document.get("groups") as! [[String: AnyObject]]
                let winners_map_list = document.get("winners") as! [[String: AnyObject]]
                let losers_map_list = document.get("losers") as! [[String: AnyObject]]
                let temp_round_dict_list = document.get("roundList") as! Data
                
                var tournament = Tournament( title: name, description: description, game_code: gc)
                
                // Creates a group from the dictionaries obtained from the database
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
                
                // Converts from "data" type from database
                do { let round_dict_list = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(temp_round_dict_list)
                    
                    
                    for dictionary_list in round_dict_list as! [[[String : AnyObject]]] {
                        var group_list = [Group]()
                        
                        for dictionary in dictionary_list{
                            
                            let g = Group( name: dictionary["name"] as! String, seed: dictionary["seed"] as! Int, status: dictionary["status"] as! Bool)
                            
                            group_list.append(g)
                        }
                        
                        tournament.roundList!.append(group_list)
                    }
                    
                }catch{}
     
                completion(tournament)
        }
    }

    // Stores the tournament in the database
    func store() {
        
        // Create list of dictionaries
        let groups_dic_list = self.groupstoDictionaryList()
        let winners_dic_list = self.winnerstoDictionaryList()
        let losers_dic_list = self.loserstoDictionaryList()
        var round_dic_list = [[[String: AnyObject]]]()
        
        for groupList in self.roundList!{
            round_dic_list.append(groupList.map(){ $0.toDictionary()})
        }
        
        var temp_round_dic_list = Data()
        
        do {
            temp_round_dic_list = try NSKeyedArchiver.archivedData(withRootObject: round_dic_list, requiringSecureCoding: false)
        }catch{}
        
        let db = Firestore.firestore()
        
        db.collection("tournaments").document(self.game_code!).setData([
            
            "title": self.title,
            "groups": groups_dic_list,
            "description" : self.description,
            "winners" : winners_dic_list,
            "losers" : losers_dic_list,
            "roundList" : temp_round_dic_list
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    // Helper functions to convert object lists to dictionaries
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


// Overloading for Tournament

func ==(lhs: Tournament, rhs: Tournament) -> Bool {
    return lhs.game_code == rhs.game_code
}
func !=(lhs: Tournament, rhs: Tournament) -> Bool {
    return !(lhs.game_code == rhs.game_code)
}

