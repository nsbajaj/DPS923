//
//  PlayerInfo.swift
//  Players
//
//  Created by Nitish Bajaj on 2018-10-08.
//  Copyright © 2018 Nitish Bajaj. All rights reserved.
//

import UIKit

class PlayerInfo: UIViewController {

    // MARK: - Instance variables
    var player: QBPerf!
    var playerImage : UIImage? = nil
    var playerTeamImage : UIImage? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var completions: UILabel!
    @IBOutlet weak var attempts: UILabel!
    @IBOutlet weak var completionPercentage: UILabel!
    @IBOutlet weak var attemptsPerGame: UILabel!
    @IBOutlet weak var yards: UILabel!
    @IBOutlet weak var averagePerCompletion: UILabel!
    @IBOutlet weak var yardsPerGame: UILabel!
    @IBOutlet weak var touchdownPasses: UILabel!
    @IBOutlet weak var interceptions: UILabel!
    @IBOutlet weak var firstDowns: UILabel!
    @IBOutlet weak var sacks: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var playerProfilePicture: UIImageView!
    @IBOutlet weak var playerTeamProfilePicture: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerName.text = player.playerName
        teamName.text = player.teamName
        rank.text = "Rank: " + String(player.rank!)
        gamesPlayed.text = "Games played: " + String(player.gamesPlayed!)
        completions.text = "Completions: " + String(player.completions!)
        attempts.text = "Attempts: " + String(player.attempts!)
        completionPercentage.text = "Completion Percentage: " + String(format: "%1.1f", player.completionPercentage!) + " %"
        attemptsPerGame.text = "Attempts per game: " + String(format: "%1.1f", player.attemptsPerGame!)
        yards.text = "Total yards: " + String(player.yards!)
        averagePerCompletion.text = "Average per completion: " + String(format: "%1.1f", player.averagePerCompletion!)
        yardsPerGame.text = "Yards per game: " + String(format: "%1.1f", player.yardsPerGame!)
        touchdownPasses.text = "Touchdown passes: " + String(player.touchdownPasses!)
        interceptions.text = "Interceptions: " + String(player.interceptions!)
        firstDowns.text = "First downs: " + String(player.firstDowns!)
        sacks.text = "Sacks: " + String(player.sacks!)
        rating.text = "Rating: " + String(format: "%1.1f", player.rating!)
        playerProfilePicture.image = playerImage
        playerTeamProfilePicture.image = playerTeamImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
