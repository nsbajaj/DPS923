//  ProvinceAdd.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

import UIKit

protocol AddProvinceDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTask(_ controller: UIViewController, didSave item: Province)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class ProvinceAdd: UIViewController {
    
    // MARK: - Instance variables
    
    weak var delegate: AddProvinceDelegate?
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var provinceName: UITextField!
    @IBOutlet weak var provincePremier: UITextField!
    @IBOutlet weak var provinceArea: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Make the provinceName text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        provinceName.becomeFirstResponder()
        
        provinceName.placeholder = "Province Name"
        provincePremier.placeholder = "Name of Premier"
        provinceArea.placeholder = "Area in square kilometers"
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
        if provinceName.text!.isEmpty {
            errorMessage.text = "Invalid province name"
            return
        }
        
        if provincePremier.text!.isEmpty {
            errorMessage.text = "Invalid premier name"
            return
        }
        
        if provinceArea.text!.isEmpty {
            errorMessage.text = "Invalid area"
            return
        }
        
        var area: Int = 0
        if let userInput = Int(provinceArea.text!){
            if(userInput > Int(0)){
                area = userInput
            }
            else{
                errorMessage.text = "Invalid area"
                return
            }
        }
        else{
            errorMessage.text = "Invalid area"
            return
        }
        
        // If we are here, the data passed the validation tests
        
        // Make an object
        let newItem = Province(name: provinceName.text!, premier: provincePremier.text!, area: area)
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Call into the delegate
        delegate?.addTask(self, didSave: newItem)
    }
}
