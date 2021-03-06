//
//  BracketController.swift
//  BracketController
//
//  Created by Mario Taglic on 4/6/19.
//  Copyright © 2019 Mario Taglic. All rights reserved.
//

import UIKit

class BracketController: UIViewController, UITableViewDataSource, UITableViewDelegate, cellInfo  {
    
    // Initializes the main bracket scene
    var bracket_scene = UIView()
    
    // Initializes the bracket backend for function calls
    let bb = bracket_backend()
    
    // Initializes a tournament
    var tournament = Tournament()
    
    // Initializes a game code
    var game_code = String()
    
    // Initializes groups to zero
    var groups:Int = 0
    
    // Initializes rounds to zero
    var rounds:Int = 0
    
    // Initializes list of matches to be used as the number of matchups per corresponding round
    var matches:[Int] = []
    
    // Initializes number of selected winners to zero
    var winnerSelectedCount = 0
    
    // Initializes the current round to zero
    var currRound:Int = 0
    
    // Initializes the list of groups in current round
    var currentGroups:[Group] = [Group]()
    
    // Initializes boolean for whether or not the user is the host
    var host:Bool = Bool()
    
    // Boolean to tell whether or not the view has been initialized
    var initialized:Bool = false
    
    // Bracket view X and Y values
    var bracketView_x = CGFloat(25)
    var bracketView_y = CGFloat(100)
    
    // Bracket view height and width values
    var bracketView_height = CGFloat(UIScreen.main.bounds.height)
    var bracketView_width = CGFloat(UIScreen.main.bounds.width * 0.8)
    
    // Bracket view dictionary and array
    var bracketViewDict:[UITableView:Int] = [:]
    var bracketViewArr:[UITableView] = []
    var bracketViewGroupDict:[UITableView: [Group]] = [:]
    
    // Translation of X and the width of the main UI
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
    
    // Set the height of the matchup cell
    var matchup_height:CGFloat = 130
    var matchup_shrinked:CGFloat = 130
    var gesture:UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.tabBar.isHidden = true
        
        
        
        Tournament.getTournament(gc: game_code){ t in
            
            self.tournament = t
            self.groups = t.getNumGroups()
            self.rounds = self.bb.generate_rounds(g: self.groups)
            self.matches = self.bb.generate_matches(r: self.rounds)
            self.currentGroups = t.winners!
            self.make_roundsHost()
            
            if !(self.initialized){
                
                self.panGestureOverBracketView()
                
            }else{
                
                for i in 0..<self.matches.count {
                    if self.currentGroups.count/2 == self.matches[i]{
                        self.currRound = i + 1
                        break
                    }
                }
                
                for i in 0..<self.currRound{
                    self.bracketViewGroupDict[self.bracketViewArr[i]] = self.tournament.roundList![i]
                }
                
            }
            
            
            self.initialized = true
            
            for tableview in self.bracketViewArr{
                
                tableview.reloadData()
            }
            
        }
        
    }
    
   
    
    // function called when the user leaves the view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //function to add a panning gesture over the table view for the bracket
    func panGestureOverBracketView(){
        bracket_scene.frame = CGRect(x:0,y:0, width: CGFloat(rounds) * main_width, height: self.view.frame.height)
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
        
        let size = bracketViewArr.count - 1
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
        
        var nextRound:Bool = false
        var startBracketAt:Int = 0
        
        if currentGroups.count == 1 {
            currRound = rounds
            nextRound = true
        }
        
        for i in 0..<matches.count {
            if currentGroups.count/2 == matches[i]{
                currRound = i + 1
                nextRound = true
                break
            }
        }
        
        if initialized{
            startBracketAt = currRound - 1
            
            if currentGroups.count == 1 {
                nextRound = false
                
            }
        }
        
        
        if (nextRound == true){
            for i in startBracketAt..<currRound{
                
                let bracket = UITableView()
                //bracket x,y, height, parameters
                bracket.frame = CGRect(x: bracketView_x, y: bracketView_y, width: bracketView_width, height: bracketView_height - 100)
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
               
                bracketViewGroupDict[bracket] = self.tournament.roundList![i]
                
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
        matchup.delegate = self
        
        matchup.setMatchup(
            g1: self.bracketViewGroupDict[tableView]![indexPath.row],
            g2: self.bracketViewGroupDict[tableView]![(self.bracketViewGroupDict[tableView]!.count - 1) - indexPath.row],
            round: self.bracketViewArr.index(of: tableView)! + 1)
        
        
       
        
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
    func updateWinner(winner: Group, loser: Group, round: Int) {
       
        self.tournament.roundList![round - 1] = self.tournament.roundList![round - 1].map(){
            
        var group = $0
            
        if (group == winner){
            group.setStatus(status: true)
        }else if (group == loser){
            group.setStatus(status: false)
        }
            return group
        }
        
        self.bracketViewGroupDict[self.bracketViewArr[round - 1]] = self.bracketViewGroupDict[self.bracketViewArr[round - 1]]!.map(){
            
            var group = $0
            
            if (group == winner){
                group.setStatus(status: true)
            }else if (group == loser){
                group.setStatus(status: false)
            }
            return group
            
        }
    
        self.tournament.makeLoser(group: loser)
        
        self.tournament.makeWinner(group: winner)
        
        //self.tournament.store()
    }
    
    func isHost() -> Bool {
        if (self.host){
            return true
        }else{
            return false
        }
        
    }
    
    func getCurrentRound() -> Int {
        return self.currRound
    }
    
    func incrementWinnerSelectedCount(){
        
        self.winnerSelectedCount += 1
        
        if (self.winnerSelectedCount >= self.matches[self.currRound - 1]){
            
            let alert = UIAlertController(title: "Complete round", message: "Do you want to end this round?", preferredStyle: .alert)
            
            let yesBtn = UIAlertAction(title: "Yes", style: .default, handler: self.nextRound)
            
            let noBtn = UIAlertAction(title: "No", style: .cancel, handler: self.returnToCurrentRound)
            
            alert.addAction(yesBtn)
            
            alert.addAction(noBtn)
            
            //alert.addAction(noBtn)
            self.present(alert,animated: true,completion: nil)
            
            
        }
        
    }
    
    func returnToCurrentRound(alert:UIAlertAction){
        
        self.winnerSelectedCount -= 1
        
        for cell in self.bracketViewArr[self.currRound - 1].visibleCells as! [MatchUpHost]{
            cell.winnerSelected = false
        }
    }
    
    func nextRound(alert:UIAlertAction){
        
        self.winnerSelectedCount = 0
        
        self.tournament.roundList!.append(self.tournament.winners!)
        
        self.tournament.store()
    }
    
}

//checking if the user is panning to the left (an extension to the UIPanGestureRecognizer
extension UIPanGestureRecognizer {
    func isLeft(passing_view: UIView) -> Bool {
        let passing_velocity : CGPoint = velocity(in: passing_view)
        if passing_velocity.x > 0 {
            
            return false
        } else {
            
            return true
        }
    }
}





// protocol to help us get the updated tournament from the next view
protocol cellInfo: class
{
    func updateWinner(winner : Group, loser : Group, round: Int)
    
    func isHost() -> Bool
    
    func getCurrentRound() -> Int
    
    func incrementWinnerSelectedCount()
}
