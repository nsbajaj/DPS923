//
//  TaskList.swift
//  Purpose - Displays the Results for a search made by the user.

//
//  Created by Nitish Bajaj on 2018-11-28.
//  Copyright © 2018 SICT. All rights reserved.

import UIKit

protocol AdddTaskDelegate {
    func selectTaskDidCancel(_ controller: UIViewController)
    func searchTask(_ controller: UIViewController, didSelect itemName: String, didSelect itemSource: String)
}

class TaskList: UITableViewController {
    
    // MARK: - Instance variables
    var m: DataModelManager!
    var delegate: AdddTaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("WebApiDataIsReady"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Method that runs when the notification happens
    @objc func reloadTableView() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return (m.package?.list.item.count)!
        
        if let count = m.package?.list.item.count{
            return count
        }
        return 0
    }
    
    // MARK: - Actions (user interface)
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.selectTaskDidCancel(self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = m.package?.list.item[indexPath.row].manu
        cell.detailTextLabel?.text = m.package?.list.item[indexPath.row].name
        
        return cell
    }
    
    // Responds to a row selection event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Work with the selected item
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            
            // Show a check mark
            selectedCell.accessoryType = .checkmark
            
            // Fetch the data for the selected item
            let name = m.package?.list.item[indexPath.row].name
            let source = m.package?.list.item[indexPath.row].manu
            
            // Call back into the delegate
            delegate?.searchTask(self, didSelect: name!, didSelect: source!)
        }
    }
}
