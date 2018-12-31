//
//  CityAdd.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

import UIKit

protocol AddCityDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTask(_ controller: UIViewController, didSave item: City)
}

class CityAdd: UIViewController {
    
    // MARK: - Instance variables
    var provinceID: Int = 0
    
    weak var delegate: AddCityDelegate?
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var cityMayor: UITextField!
    @IBOutlet weak var cityPopulation: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Make the provinceName text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityName.becomeFirstResponder()
        
        cityName.placeholder = "Province Name"
        cityMayor.placeholder = "Name of Premier"
        cityPopulation.placeholder = "Area in square kilometers"
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Call into the delegate
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        if cityName.text!.isEmpty {
            errorMessage.text = "Invalid city name"
            return
        }
        
        if cityMayor.text!.isEmpty {
            errorMessage.text = "Invalid mayor name"
            return
        }
        
        if cityPopulation.text!.isEmpty {
            errorMessage.text = "Invalid population"
            return
        }
        
        var population: Int = 0
        if let userInput = Int(cityPopulation.text!){
            if(userInput > Int(0)){
                population = userInput
            }
            else{
                errorMessage.text = "Invalid population"
                return
            }
        }
        else{
            errorMessage.text = "Invalid population"
            return
        }
        
        // If we are here, the data passed the validation tests
        // Make an object
        
        let newItem = City(name: cityName.text!, mayor: cityMayor.text!, population: population, province: provinceID)
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Call into the delegate
        delegate?.addTask(self, didSave: newItem)
    }
}
