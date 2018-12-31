//
//  PlayerList.swift
//  Players
//
//  Created by Nitish Bajaj on 2018-10-02.
//  Copyright © 2018 Nitish Bajaj. All rights reserved.
//

import UIKit


class PlayerList: UITableViewController {
    
    // MARK: - Instance variables
    var playerImage : UIImage? = nil
    var playerTeamImage : UIImage? = nil
    let extention = ".png"
    
    // Get a reference to the data manager
    let mInfo = QBInfoManager.sharedManager
    let mPerf = QBPerfManager.sharedManager
    
    // Create a local collection to hold the data
    var qbInfo: [QBInfo] = []
    var qbPerf: [QBPerf] = []
    
    // Then, in viewDidLoad(), fetch the data
    
    // At this point in time, the qbInfo array will have
    // all the player personal info, ready for display
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        qbInfo = mInfo.allQBInfos()
        qbPerf = mPerf.allQBPerfs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return qbInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PlayersItem",
            for: indexPath)

        // Configure the cell...
        //updatePlayerPicture(indexPath: indexPath)
        updatePlayerPicture(indexPath: indexPath)
        
        cell.textLabel?.text = qbInfo[indexPath.row].playerName
        cell.detailTextLabel?.text = qbInfo[indexPath.row].teamName;
        cell.imageView?.image = playerImage
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // Verify that we can get the selected row's index path
        // and that it is associated with data in the app's data model
        
        // If it's a row selection/tap, then deselect the row
        if let ipSelected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: ipSelected, animated: true)
        }
        
        // Perform two checks...
        // 1. Ensure that we can get an index path, and
        // 2. Ensure that it associated with valid data
        if let ip = tableView.indexPath(for: sender as! UITableViewCell) {
            if qbInfo.indices.contains(ip.row) {
                return true
            }
            else {
                // Before the return, we can optionally
                // notify or alert the user about the problem
                return false
            }
        } else {
            // Before the return, we can optionally
            // notify or alert the user about the problem
            return false
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toPlayerDetail" {
            let vc = segue.destination as! PlayerDetail
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            // use the index path to fetch what you want from the data model
            // assume that "arrayDataSource" is an array, and the data source
            let selectedData = qbInfo[(indexPath?.row)!]
            
            // pass it on (set the destination controller's data property)
            // assume that the destination controller has a "dataObject" property
            vc.player = selectedData
            
            updatePlayerPicture(indexPath: indexPath!) //Updates the "playerImage" variable, so that the variable is updated with a picture when the user selects a player everytime.
            vc.playerImage = playerImage;
            
            updatePlayerTeamPicture(indexPath: indexPath!) //Updates player team image
            vc.playerTeamImage = playerTeamImage;
            
            // if necessary, pass on a reference to the app's data model manager
            // assume that "model" is the name of the data model manager variable
            //vc.model = model
            
            // set the destination controller's title property
            // assume that selectedData has an "appropriateTitleText" property
            vc.title = qbInfo[(indexPath?.row)!].playerName
        }
        
        if segue.identifier == "toPlayerInfo" {
            let vc = segue.destination as! PlayerInfo
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            // use the index path to fetch what you want from the data model
            // assume that "arrayDataSource" is an array, and the data source
            let selectedData = qbPerf[(indexPath?.row)!]
            
            // pass it on (set the destination controller's data property)
            // assume that the destination controller has a "dataObject" property
            vc.player = selectedData
            
            updatePlayerPicture(indexPath: indexPath!)
            vc.playerImage = playerImage;
            
            updatePlayerTeamPicture(indexPath: indexPath!)
            vc.playerTeamImage = playerTeamImage;
            
            // if necessary, pass on a reference to the app's data model manager
            // assume that "model" is the name of the data model manager variable
            //vc.model = model
            
            // set the destination controller's title property
            // assume that selectedData has an "appropriateTitleText" property
            vc.title = qbPerf[(indexPath?.row)!].playerName
        }
    }
    
    /*
     This function updates the "playerImage" variable with a player picture, everytime it is called.
     */
    func updatePlayerPicture(indexPath: IndexPath){
        var playerPhoto = "a2-assets-v2/a2-player-photos/a2 "
        if let _ = qbInfo[indexPath.row].playerName {
            playerPhoto.append(qbInfo[indexPath.row].playerName!);
        }
        playerPhoto = playerPhoto.replacingOccurrences(of: " ", with: "-")
        playerPhoto.append(extention)
        playerPhoto = playerPhoto.lowercased()
        playerImage = UIImage(named: playerPhoto)
    }
    
    /*
     This function updates the "playerTeamImage" variable with a player team picture, everytime it is called.
     */
    func updatePlayerTeamPicture(indexPath: IndexPath){
        var playerTeamPhoto = "a2-assets-v2/a2-team-logos/"
        if let _ = qbInfo[indexPath.row].teamCode {
            playerTeamPhoto.append(qbInfo[indexPath.row].teamCode!);
        }
        playerTeamPhoto = playerTeamPhoto.replacingOccurrences(of: " ", with: "-")
        playerTeamPhoto.append(extention)
        playerTeamImage = UIImage(named: playerTeamPhoto)
    }
}
