//
//  Group.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import Foundation

struct Group {
    
    // Name of group
    var name:String?
    
    // Seed of group
    var seed:Int?
    
    // Status of group (Whether or not this group has been selected as a winner)
    var status:Bool = false
    
    // Function to convert Group object to a dictionary
    func toDictionary() -> [String: AnyObject]{
        return ["name": self.name as AnyObject, "seed": self.seed as AnyObject, "status": self.status as AnyObject]
    }
    
    // Function to return the seed of a group
    func getSeed()->Int{
        return self.seed!
    }
    
    // Function to set the status of the group
    mutating func setStatus(status: Bool){
        self.status = status
    }
    
}


//Overloading for Group
func ==(lhs: Group, rhs: Group) -> Bool {
    return lhs.name == rhs.name
}

func !=(lhs: Group, rhs: Group) -> Bool {
    return !(lhs.name == rhs.name)
}


