//
//  FoodItemDetail.swift
//  Purpose - Control the "next" scene in the nav Disclosure workflow
//  This is a standard view controller
//  It is within a navigation workflow, with a presenter, and a maybe a successor
//

import UIKit

class FoodItemDetail: UIViewController {
    
    // MARK: - Public properties (instance variables)
    var m: DataModelManager!
    
    // Passed-in object, if necessary
    var item: FoodItem!
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemQuantity: UILabel!
    @IBOutlet weak var foodItemSource: UILabel!
    @IBOutlet weak var foodItemDate: UILabel!
    @IBOutlet weak var foodItemLongLat: UILabel!
    @IBOutlet weak var foodItemLocation: UILabel!
    @IBOutlet weak var foodItemPicture: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item != nil{
            foodItemName.text = item.name
            foodItemQuantity.text = String(item.quantity) + " grams"
            foodItemSource.text = item.source
            
            let df = DateFormatter()
            df.dateStyle = .long
            df.timeStyle = .short
            foodItemDate.text = df.string(from: item.timestamp!)
            
            let latitude = String(format: "%.4f", item.lat)
            let longitude = String(format: "%.4f", item.lon)
            foodItemLongLat.text = "Latitude " + latitude + ", Longitude " + longitude
            
            foodItemLocation.text = item.location
            
            if item.photo != nil{
                // Attempt to create a UIImage representation of the photo
                let photo = UIImage(data: item.photo!)
                foodItemPicture.image = photo
            }
        }
    }
}
