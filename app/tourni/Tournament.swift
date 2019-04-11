//
//  Tournament.swift
//  tourni
//
//  Created by Administrator on 4/10/19.
//  Copyright © 2019 group13. All rights reserved.
//
import Firebase
import Foundation

struct Group {
    var name:String
    var seed:Int
    var status:Bool = true
}


struct Tournament {
    var title:String
    var groups:[Group]?
    var description:String?
    var game_code:String
    var winners:[Group]?
    var losers:[Group]?
    
    init(title: String,
        groups: [Group]? = nil,
        description: String? = nil,
        game_code: String,
        winners: [Group]? = nil,
        losers: [Group]? = nil) {
        
        self.title = title
        self.groups = groups
        self.description = description
        self.game_code = game_code
        self.winners = winners
        self.losers = losers
    }
    
    func store() {
        let db = Firestore.firestore()
        
        db.collection("tournaments").document(self.game_code).setData([
            "title": self.title,
            "groups": self.groups!.count,
            "description" : self.description
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
}
