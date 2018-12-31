//
//  CityDetail.swift
//  Purpose - Displays the details of a city
//  This is a standard view controller
//  It is within a navigation workflow, with a presenter, and a successor
//

import UIKit

class CityDetail: UIViewController {
    
    // MARK: - Instance variables
    
    var city: City!
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityMayor: UILabel!
    @IBOutlet weak var cityPopulation: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cityName.text = city.name
        cityMayor.text = "Mayor is " + city.mayor
        cityPopulation.text = "Populaion is " + String(city.population)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Actions (user interface)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
        
    }
}
