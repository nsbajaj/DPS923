//
//  AddFoodItem.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented
//

import UIKit
import CoreLocation

//Delegate
protocol AddFoodItemDelegate: class {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTaskDidSave(_ controller: UIViewController)
}

class FoodItemAdd: UIViewController, CLLocationManagerDelegate, AdddTaskDelegate{
   
    // MARK: - Instance variables
    weak var delegate: AddFoodItemDelegate?
    
    //Location Variabels
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var locationRequests: Int = 0
    
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var placemarkText = "(location not available)"
    
    //Photo
    var photo: UIImage?
    
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var foodItemName: UITextField!
    @IBOutlet weak var foodItemSource: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var foodItemNotes: UITextField!
    @IBOutlet weak var quantity: UISegmentedControl!
    @IBOutlet weak var foodItemPicture: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodItemName.becomeFirstResponder()
    }
    
    // MARK: - Actions (user interface)
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        if foodItemName.text!.isEmpty {
            errorMessage.text = "Invalid name"
            return
        }
        
        if foodItemSource.text!.isEmpty {
            errorMessage.text = "Invalid source"
            return
        }
        
        //Just to be safe
        var quantityValue = ""
        if quantity.selectedSegmentIndex < 0 || quantity.selectedSegmentIndex > 5 {
            errorMessage.text = "Invalid quantity"
            return
        }
        else{
            quantityValue = quantity.titleForSegment(at: quantity.selectedSegmentIndex)!
        }
        
        if foodItemNotes.text!.isEmpty {
            errorMessage.text = "Invalid notes"
            return
        }
        
        // If we are here, the data passed the validation tests
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Make an object, configure and save
        if let newItem = m.foodItem_CreateItem() {
            newItem.name = foodItemName.text
            newItem.source = foodItemSource.text
            newItem.notes = foodItemSource.text
            if let userQuantity = Int32(quantityValue){
                newItem.quantity = userQuantity
            }
            
            let currentDate = Date()
            newItem.timestamp = currentDate
            
            if location?.coordinate.latitude != nil{
                newItem.lat = (location?.coordinate.latitude)!
            }
            if location?.coordinate.longitude != nil{
                newItem.lon = (location?.coordinate.longitude)!
            }
            if !self.placemarkText.isEmpty {
                newItem.location = self.placemarkText
            }
            
            // Attempt to create a Data representation of the photo
            //If no picture is attached, won't set a picture.
            if photo != nil{
                //Attempt to convert FROM a UIImage TO a Data
                guard let imageData  = UIImageJPEGRepresentation(photo!, 1.0) else {
                    errorMessage.text = "Cannot save photo."
                    return
                }
                newItem.photo = imageData
                
                //Resizing to 25 for thumbnail
                let thumb = photo?.getThumbnailImage(25);
                
                //Attempt to convert FROM a UIImage TO a Data
                guard let imageDataThumb  = UIImageJPEGRepresentation(thumb!, 1.0) else {
                    errorMessage.text = "Cannot save photo"
                    return
                }
                newItem.photoThumbnail = imageDataThumb
            }
            m.ds_save()
        }
        
        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }
    
    private func getLocation() {
        // These two statements setup and configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        
        // Determine whether the app can use location services
        let authStatus = CLLocationManager.authorizationStatus()
        
        // If the app user has never been asked before, then ask
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // If the app user has previously denied location services, do this
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        // If we are here, it means that we can use location services
        // This statement starts updating its location
        locationManager.startUpdatingLocation()
    }
    
    // Respond to a previously-denied request to use location services
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Build a nice string from a placemark
    // If you want a different format, do it
    private func makePlacemarkText(from placemark: CLPlacemark) -> String {
        
        var s = ""
        s.append(placemark.subThoroughfare!)
        s.append(" \(placemark.thoroughfare!)")
        s.append(", \(placemark.locality!) \(placemark.administrativeArea!)")
        s.append(", \(placemark.postalCode!) \(placemark.country!)")
        
        return s
    }
    
    // MARK: - Delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // When location services is requested for the first time,
        // the app user is asked for permission to use location services
        // After the permission is determined, this method is called by the location manager
        
        // If the permission is granted, we want to start updating the location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("\nUnable to use location services: \(error)")
    }
    
    // This is called repeatedly by the iOS runtime,
    // as the location changes and/or the accuracy improves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Here is how you can configure an arbitrary limit to the number of updates
        if locationRequests > 10 { locationManager.stopUpdatingLocation() }
        
        // Save the new location to the class instance variable
        location = locations.last!
        
        // Info to the programmer
        //print("\nUpdate successful: \(location!)")
        //print("\nLatitude \(location?.coordinate.latitude ?? 0)\nLongitude \(location?.coordinate.longitude ?? 0)")
        
        // Do the reverse geocode task
        // It takes a function as an argument to completionHandler
        geocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            
            // We're looking for a happy response, if so, continue
            if error == nil, let p = placemarks, !p.isEmpty {
                
                // "placemarks" is an array of CLPlacemark objects
                // For most geocoding requests, the array has only one value,
                // so we will use the last (most recent) value
                // Format and save the text from the placemark into the class instance variable
                self.placemarkText = self.makePlacemarkText(from: p.last!)
            }
        })
        
        locationRequests += 1
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toTaskList" {
            //Validate the data from the user interface. If the food item name text field is empty, then show an error message, and return "false"
            if foodItemName.text!.isEmpty {
                errorMessage.text = "Must enter a food item name."
                return false
            }
            //However, if it is not empty, call the manager's "foodItem_Search(searchTerms:)" method
            else{
                m.foodItem_Search(searchTerms: foodItemName.text!)
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskList" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! TaskList
            
            // Set other properties
            vc.title = "Search for " + foodItemName.text!
            // Pass on the data model manager, if necessary
            vc.m = m
            // Set the delegate, if configured
            vc.delegate = self
        }
    }
    
    //Add picture
    @IBAction func picture(_ sender: UIButton) {
        getPhotoWithCameraOrPhotoLibrary()
    }
    
    func selectTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchTask(_ controller: UIViewController, didSelect itemName: String, didSelect itemSource: String) {
        foodItemName.text?.removeAll()
        foodItemName.text = itemName
        foodItemSource.text = itemSource
        dismiss(animated: true, completion: nil)
    }
}
