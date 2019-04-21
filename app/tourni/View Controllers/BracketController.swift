//
//  bracket_maker.swift
//  bracket_maker
//
//  Created by Mario Taglic on 4/6/19.    let bracket_algo = bracket_backend()
//  Copyright © 2019 Mario Taglic. All rights reserved.
//

import UIKit

class BracketController: UIViewController, UITableViewDataSource, UITableViewDelegate, cellInfo  {
    
    let bracket_scene = UIView()
    let bb = bracket_backend()
    var tournament = Tournament()
    var game_code = String()
    var bracket_table_view = UITableView()
    var groups:Int = 0
    var rounds:Int = 0
    var matches:[Int] = []
    
    
    
    
    //variable intilization for the number of rounds, matches
    //FIX FOR DYNAMIC VARIABLE FROM THE DATABASE
    
    //bracket view X and Y values
    var bracketView_x = CGFloat(25)
    var bracketView_y = CGFloat(0)
    
    //bracket view height and width values
    var bracketView_height = CGFloat(UIScreen.main.bounds.height - 40)
    var bracketView_width = CGFloat(UIScreen.main.bounds.width * 0.8)
    
    //bracket view dictionary and array
    var bracketViewDict:[UITableView:Int] = [:]
    var bracketViewArr:[UITableView] = []
    
    //translation of X and the width of the main UI
    var translationX:CGFloat = 0
    var main_width = UIScreen.main.bounds.width
    
    var page = 0{
        didSet{
            for table in bracketViewArr{
                table.frame.origin.y = bracketView_y
                table.beginUpdates()
                table.endUpdates()
            }
        }
    }
    
    //set the height of the matchup
    var matchup_height:CGFloat = 130
    var matchup_shrinked:CGFloat = 120
    
    var gesture:UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        Tournament.getTournament(gc: game_code){ t in
            
            self.tournament = t
            self.groups = t.getNumWinners()
            self.rounds = self.bb.generate_rounds(g: self.groups)
            self.matches = self.bb.generate_matches(r: self.rounds)
            self.make_roundsHost()
            self.panGestureOverBracketView()
            
        }
    }
    
    
    //function to add a panning gesture over the table view for the bracket
    func panGestureOverBracketView(){
        bracket_scene.frame = CGRect(x:0,y:20, width: CGFloat(rounds) * main_width, height: self.view.frame.height)
        self.view.addSubview(bracket_scene)
        
        gesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureOverBracketViewHandler(panGesture:)))
        
        //number of touches to pan through the bracket
        gesture?.minimumNumberOfTouches = 1
        self.bracket_scene.addGestureRecognizer(gesture!)
        
        //scene background color (note: should match the bracket background color)
        bracket_scene.backgroundColor = .clear
    }
    
    @objc func panGestureOverBracketViewHandler(panGesture recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if  recognizer.state == .began ||  recognizer.state == .changed{
            recognizer.view!.center.x = recognizer.view!.center.x + translation.x
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            translationX = translation.x
        }else if recognizer.state == .ended{
            if !recognizer.isLeft(passing_view: self.bracket_scene){//If gesture went right
                if page == 0{
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0)
                        self.page = 0
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.bracketView_width  * CGFloat(self.page - 1)))
                        self.page -= 1
                    })
                    
                }
                
            }else{//Gesture went left
                
                if page == bracketViewArr.count - 1{
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.bracketView_width  * CGFloat(self.page)))
                        
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.bracketView_width  * CGFloat(self.page + 1)))
                        self.page += 1
                    })
                    
                }
                
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let size = bracketViewArr.count
        if size <= page + 1{
            return
        }
        
        if scrollView == bracketViewArr[page + 1] && page < size{
            bracketViewArr[page].contentOffset = scrollView.contentOffset
            
        }
        else if scrollView == bracketViewArr[page] && page+1 < size{
            bracketViewArr[page+1].contentOffset = scrollView.contentOffset
        }
        
    }
    
    
    
    //function to make the correct number of rounds for the tournament
    func make_roundsHost() {
        var r:Int = 0
        var nextRound:Bool = false
        for i in 0..<matches.count{
            if groups/2 == matches[i]{
             r=r+1
             nextRound = true
            }
        }
        if nextRound == true{
            for i in 0..<rounds{
                let bracket = UITableView()
                self.bracket_table_view = bracket
                //bracket x,y, height, parameters
                bracket.frame = CGRect(x: bracketView_x, y: bracketView_y, width: bracketView_width, height: bracketView_height)
                bracketView_x+=bracketView_width
                
                //bracket background color
                bracket.backgroundColor = .white
                
                bracket.delegate = self
                bracket.dataSource = self
                //our own asset must go in here
                bracket.register(UINib(nibName: "MatchUpHost", bundle: nil), forCellReuseIdentifier: "MatchUpHost")
                bracket.separatorStyle = .none
                
                //to show the correct number of rounds in the bracket
                bracketViewDict[bracket] = matches[i]
                
                //adding the bracket to the array
                bracketViewArr.append(bracket)
                
                //show the bracket on the bracket_scene
                self.bracket_scene.addSubview(bracket)
                nextRound = false
                bracket.reloadData()
            }
            
        }
        
    }
    
    
    //automatically generated for UITableViewDataSource and UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bracketViewDict[tableView]!
    }
    
    func numberOfSections(in tableView: UITableView)-> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let matchup = tableView.dequeueReusableCell(withIdentifier: "MatchUpHost", for: indexPath) as! MatchUpHost
        
        // makes matchups unselectable
        matchup.selectionStyle = UITableViewCell.SelectionStyle.none
        matchup.winnerDelegate = self
        
        matchup.setMatchup(g1: tournament.groups![indexPath.row], g2: tournament.groups![(groups - 1) - indexPath.row])
        
        
       
        
        return matchup
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if page - 1 >= 0{
            if tableView == bracketViewArr[page - 1]{ return matchup_shrinked }
            else if tableView == bracketViewArr[page]{ return  matchup_height }
            else{
                if page + 1 < bracketViewArr.count{
                    if tableView == bracketViewArr[page + 1]{
                        if page + 1 == bracketViewArr.count - 1{return matchup_height*2}else{ return  CGFloat(page) * matchup_height }
                    }
                }
            }
            //the current page is equal to 0
        }else{
            return tableView == bracketViewArr[0]  ? matchup_height : 2*matchup_height
        }
        return 0
    }
    
    // function called when a winner is updated (Winner followed by loser)
    func updateWinner(winner: Group, loser: Group) {
        
        
        self.tournament.makeLoser(group: loser)
        
        self.tournament.makeWinner(group: winner)
        
        //self.tournament.store()
    }
    
    func isHost() -> Bool {
        return false
    }
}

//checking if the user is panning to the left (an extension to the UIPanGestureRecognizer
extension UIPanGestureRecognizer {
    func isLeft(passing_view: UIView) -> Bool {
        let passing_velocity : CGPoint = velocity(in: passing_view)
        if passing_velocity.x > 0 {
            print("Gesture went right")
            return false
        } else {
            print("Gesture went left")
            return true
        }
    }
}



// protocol to help us get the updated tournament from the next view
protocol cellInfo: class
{
    func updateWinner(winner : Group, loser : Group)
    
    func isHost() -> Bool
}
