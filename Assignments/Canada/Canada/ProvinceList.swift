//  ProvinceListBase.swift
//  Purpose - Shows content for a collection, in a table view
//  This is a table view controller
//  Can be used anywhere in the navigation workflow (start, mid, end)

import UIKit

// Adopt the protocols that are appropriate for this controller

class ProvinceList: UITableViewController, ShowProvinceDetailDelegate, AddProvinceDelegate{
    
    // MARK: - Instance variables
    
    // Use if a collection is passed in, or fetched from data model manager
    var items = [Province]()
    
    //Data Model Manager
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the locally-defined instance variable for the collection
        items = m.province
        
        // Set a title here or on the storyboard scene
        title = "Provinces"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // We must refresh the data in the table view
        // First, refresh the data source
        items = m.provincesSortedByName()
        // Then, ask the table view to reload itself
        tableView.reloadData()
    }
    
    // MARK: - Table view building
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // For many apps done in the DPS923/MAP523 course, there is one (1) section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Get this value from the "count" of the collection that's used in the table view
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // #warning Match the value "cell" with the value used on the prototype cell attributes inspector in the storyboard editor
        
        // Configure the cell...
        
        // Get the object we want
        let item = items[indexPath.row]
        
        // Configure the UI objects
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            // Remember that the table view "data source" is NOT the same
            // as the table view "rows"
            
            // First, get the row data, so we can get its identifier
            let item = m.province[indexPath.row]
            
            // Next, attempt to delete the item from the data source
            if m.provinceDelete(item.id) {
                // Yes, successful, so continue...
                // Refresh the data source
                items = m.provincesSortedByName()
                // Remove the row
                tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table view
                tableView.reloadData()
            }
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
       
        if segue.identifier == "toCitiesList" {
            // Get a reference to the next controller
            // Next controller is managed by the current nav controller
            let vc = segue.destination as! CityList
           
            // Fetch and prepare the data to be passed on
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = items[indexPath!.row]
            
            // Set other properties
            vc.item = selectedData
            vc.title = "Cities in " + selectedData.name
            
            // Pass on the data model manager, if necessary
            vc.m = m
        }
        
        if segue.identifier == "toProvinceAdd" {
            // Get a reference to the controller
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! ProvinceAdd
            
            // Set other properties
            //vc.item = selectedData
            vc.title = "Add Province"
            
            // Set the delegate, if configured
            vc.delegate = self
        }
        
        if segue.identifier == "toProvinceDetail" {
            if let nav = segue.destination as? UINavigationController, let ProvinceDetail = nav.topViewController as? ProvinceDetail {
                ProvinceDetail.delegate = self
                
                let vc = nav.viewControllers[0] as! ProvinceDetail
                
                let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
                
                // use the index path to fetch what you want from the data model
                // assume that "arrayDataSource" is an array, and the data source
                let selectedData = items[(indexPath?.row)!]
                
                // pass it on (set the destination controller's data property)
                // assume that the destination controller has a "dataObject" property
                vc.item = selectedData
                
                // set the destination controller's title property
                // assume that selectedData has an "appropriateTitleText" property
                vc.title = items[(indexPath?.row)!].name
            }
        }
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: Province) {
        // In general, the item type is suggested as Any, which you can cast, or...
        // Recommendation - change the type to match the actual item type
        
        // Attempt to save the new product
        if m.provinceAdd(item) != nil {
            m.savePlist()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showDetailDone(_ controller: UIViewController) {
        // Dismiss the "show detail" controller and scene
        dismiss(animated: true, completion: nil)
    }
}
