//
//  FoodItemList.swift
//  Purpose - Shows content for a collection, in a table view
//  This is a table view controller
//  Can be used anywhere in the navigation workflow (start, mid, end)
//

import UIKit
import CoreData

class FoodItemList: ListBaseCD, AddFoodItemDelegate{
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTaskDidSave(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private internal instance variables
    
    // Configure the desired entity type in the frc
    private var frc: NSFetchedResultsController<FoodItem>!
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    //var item: FoodItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure nav items
        title = "Food Items"
        
        // If desired, configure the table view edit capability
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Configure the frc for the desired entity type, sort is case-insensitive
        frc = m.ds_frcForEntityNamed("FoodItem", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))], andSectionNameKeyPath: nil)
        
        // This controller will be the frc delegate
        frc.delegate = self;
        
        // Perform fetch, and if there's an error, log it
        do {
            try frc.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Actions (user interface)
    
    // MARK: - Table view building
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = frc.object(at: indexPath) 
        cell.textLabel!.text = item.name
        cell.detailTextLabel?.text = "Quantity is \(item.quantity)"
        
        if item.photoThumbnail != nil{
            let photo = UIImage(data: item.photoThumbnail!)
            cell.imageView?.image = photo
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = frc.object(at: indexPath)
            m.foodItem_DeleteItem(item: item)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodItemAdd" {
            // Get a reference to the controller
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! FoodItemAdd
            
            vc.m = m
            
            // Set the delegate, if configured
            vc.delegate = self
        }
        if segue.identifier == "toFoodItemDetail" {
            let vc = segue.destination as! FoodItemDetail
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = frc.object(at: indexPath!)
            
            vc.item = selectedData
            vc.title = selectedData.name
        }
    }
}
