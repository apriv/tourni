//
//  Group.swift
//  tourni
//
//  Created by Justin Russo on 4/12/19.
//  Copyright © 2019 group13. All rights reserved.
//

import Foundation

struct Group {
    var name:String
    var seed:Int
    var status:Bool = true
    
    
    func toDictionary() -> [String: AnyObject]{
        return ["name": self.name as AnyObject, "seed": self.seed as AnyObject, "status": self.status as AnyObject]
    }
    
    func getSeed()-> Int{
        return self.seed
    }
    
    func getName()-> String{
        return self.name
    }
}
