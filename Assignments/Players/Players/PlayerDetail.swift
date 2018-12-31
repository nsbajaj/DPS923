//
//  PlayerDetail.swift
//  Players
//
//  Created by Nitish Bajaj on 2018-10-05.
//  Copyright © 2018 Nitish Bajaj. All rights reserved.
//

import UIKit

class PlayerDetail: UIViewController {
    
    // MARK: - Instance variables
    var player: QBInfo!
    var playerImage : UIImage? = nil
    var playerTeamImage : UIImage? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var physical: UILabel!
    @IBOutlet weak var birthdateAndPlace: UILabel!
    @IBOutlet weak var college: UILabel!
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var highSchool: UILabel!
    @IBOutlet weak var playerProfilePicture: UIImageView!
    @IBOutlet weak var playerTeamProfilePicture: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerName.text = player.playerName! + " " + player.playerNumber!
        teamName.text = player.teamName
        physical.text = player.physical
        birthdateAndPlace.text = player.birthdateAndPlace
        college.text = player.college
        experience.text = player.experience
        highSchool.text = player.highSchool
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
