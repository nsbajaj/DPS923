//  ProductDetail.swift
//  Purpose - Shows content for a Detail accessory
//  This is a standard view controller, modally-presented

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

import UIKit

protocol ShowProvinceDetailDelegate: class {
    func showDetailDone(_ controller: UIViewController)
}

class ProvinceDetail: UIViewController {

    // MARK: - Instance variables
    
    weak var delegate: ShowProvinceDetailDelegate?
    
    var item: Province!

    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var provinceName: UILabel!
    @IBOutlet weak var provincePremier: UILabel!
    @IBOutlet weak var provinceArea: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        provinceName.text = item.name
        provincePremier.text = "Province Premier is " + item.premier
        provinceArea.text = "Province Area is " + String(item.area)
    }
    
    // MARK: - Actions (user interface)
    
    // This controller's scene has a nav bar button "Done"

    @IBAction func done(_ sender: UIBarButtonItem) {
        // Call into the delegate
        delegate?.showDetailDone(self)
    }
}
