//  bracket_maker
//
//  Created by Mario Taglic on 4/11/19.
//  Copyright © 2019 Mario Taglic. All rights reserved.
//

import Foundation
class bracket_backend {
    //HELPER FUNCTIONS
    /*function: isPowerOfTwo
     *checks if the number is a power of two
     *returns true or false
     */
    func isPowerOfTwo(_ n: Int) -> Bool {
        return (n > 0) && (n & (n - 1) == 0)
        
    }
    /*generate the number of rounds for each tournament
     *parameters: the number of groups in the tournament (Type: Int)
     *returns the number of rounds (Type: Int)
     */
    func generate_rounds(g: Int) -> Int{
        //intialize variables
        var rounds:Int = 0
        var size:Int = g
        var validInput:Bool = true
        //checking if the number of groups is greater than 0
        if size <= 0{ validInput = false}
        if(validInput == true){
            //count the number of rounds until there is only one group left (the winner of the tournament)
            while(size > 1){
                size = size/2
                rounds = rounds + 1
            }
            
        }
        return rounds
        
    }
    
    /*generate the number of match ups for each tournament
     *parameters: the number of rounds in the tournament (Type: Int)
     *returns the number of match ups for each round of the tournament (Type: [Int])
     */
    
    func generate_matches(r: Int)->[Int]{
        //intialize all the variables
        var match_upList:[Int] = []
        var numOfMatchUps:Int = Int(powf(Float(2), Float(r)))/2
        //get the number of rounds for tournament
        //create enough match ups based on the number of rounds
        for _ in 0..<r{
            match_upList.append(numOfMatchUps)
            numOfMatchUps = numOfMatchUps/2
            //push data into the [(string, string)]
        }
        return match_upList
    }
}


