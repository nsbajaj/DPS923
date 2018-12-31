//
//  CityList.swift
//  Purpose - Shows content for a collection, in a table view
//  This is a table view controller

import UIKit

class CityList: UITableViewController, AddCityDelegate{
    
    // MARK: - Instance variables
    
    // Use if a collection is passed in, or fetched from data model manager
    var items = [City]()
    var item: Province!
    
    //data model manager
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the cities in a province
        items = item.cities
        
        // Set a title here or on the storyboard scene
        title = "Cities in " + item.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // We must refresh the data in the table view
        // First, refresh the data source
        items = m.citiesSortedById(provinceID: item.id)
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
        return item.cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // #warning Match the value "cell" with the value used on the prototype cell attributes inspector in the storyboard editor
        
        // Configure the cell...
        
        // Get the object we want
        if(item.cities.count > 0){
            let cities = item.cities[indexPath.row]
            // Configure the UI objects
            cell.textLabel?.text = cities.name
        }
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
            //let item = m.products[indexPath.row]
            
            // Next, attempt to delete the item from the data source
            /*
            if m.productDelete(item.id) {
                // Yes, successful, so continue...
                // Refresh the data source
                items = m.productsSortedByName()
                // Remove the row
                tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table view
                tableView.reloadData()
            }
             */
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
        if segue.identifier == "toCityScene" {
            let vc = segue.destination as! CityDetail
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            let selectedData = items[(indexPath?.row)!]
            
            vc.city = selectedData
            vc.title = selectedData.name
        }
        if segue.identifier == "toCityAdd" {
            // Get a reference to the controller
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CityAdd
            
            //Setting the title and passing in the province ID
            vc.title = "Add " + item.name + " City"
            vc.provinceID = item.id
        
            vc.delegate = self
        }
    }
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave newItem: City) {
        // In general, the item type is suggested as Any, which you can cast, or...
        // Recommendation - change the type to match the actual item type
        // Attempt to save the new product
        
        if m.cityAdd(newItem) != nil {
            m.savePlist()
            dismiss(animated: true, completion: nil)
        }
    }
}
