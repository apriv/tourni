//
//  Group.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import Foundation

struct Group {
    var name:String?
    var seed:Int?
    var status:Bool = false
    
    
    func toDictionary() -> [String: AnyObject]{
        return ["name": self.name as AnyObject, "seed": self.seed as AnyObject, "status": self.status as AnyObject]
    }
    
    func getSeed()->Int{
        return self.seed!
    }
    
    mutating func setStatus(status: Bool){
        self.status = status
    }
    
}


//Overloading for Tournament


func ==(lhs: Group, rhs: Group) -> Bool {
    return lhs.name == rhs.name
}
func !=(lhs: Group, rhs: Group) -> Bool {
    return !(lhs.name == rhs.name)
}
