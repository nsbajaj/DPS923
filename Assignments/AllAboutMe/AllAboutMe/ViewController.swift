//
//  ViewController.swift
//  AllAboutMe
//
//  Created by Nitish Bajaj on 2018-09-17.
//  Copyright © 2018 Nitish Bajaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Local fields
    var gpa = "";
    
    // MARK: - Outlets
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var programSelector: UISegmentedControl!
    @IBOutlet weak var levelSelector: UISegmentedControl!
    @IBOutlet weak var gpaSelector: UISlider!
    @IBOutlet weak var gpaInput: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        programSelector.selectedSegmentIndex = 1; //Setting program
        levelSelector.selectedSegmentIndex = 1; //Setting Level
        gpaSelector.value = 3.40; //Setting Slider value
        gpaInput.text = String(format: "%1.2f", gpaSelector.value); //Formatting and setting UITextField value
        gpa = String(format: "%1.2f", 3.40); //Setting local member variable (GPA) value
        updateResultText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    /*This function calls updateResultText() action, when UISegmentedControl "programSelector" detects a change in value.*/
    @IBAction func programChanged(_ sender: UISegmentedControl) {
        updateResultText()
    }
    
    /*This function calls updateResultText() action, when UISegmentedControl "levelSelector" detects a change.*/
    @IBAction func levelChanged(_ sender: UISegmentedControl) {
        updateResultText()
    }
    
    /*This function calls updateResultText(), when the user begins moving the UISlider "gpaSelector" on screen. It then formats the value to as "%1.2f", updates the "gpaInput" UITextField and calls updateResultText action.*/
    @IBAction func gpaSelectorChanged(_ sender: UISlider) {
        gpa = String(format: "%1.2f", gpaSelector.value)
        gpaInput.text = gpa;
        updateResultText()
    }
    
    /*This function calls the updateResultText() function.*/
    @IBAction func gpaInputChanged(_ sender: UITextField) {
        updateResultText()
    }
    
    /*This function is called when the "Done" button is pressed on the keyboard.*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    /*
     This function reads the value inserted by the user through UITextField, Slider and performs validations, making sure the user inputs value between 2 and 4.
     It also updates rounds the value to "%1.2f" format in the UITextField. If CPA is selected as the program, Level 7 and 8 will be greyed out .
     It also updates the UITextView, so the output shows what the user inserted and selected.
     */
    func updateResultText(){
        // Read the results from the user interface
        var value = Float(2);
        //Checking if gpaInput.text is empty.
        if(gpaInput.text?.isEmpty ?? true){
            value = Float(2)
        }
        //If gpaInput.text is not empty
        else{
            //gpaInput.text  is converted into a Float. If it is converted sucessfully, it will continue validating the input. If not, it will reset the gpaInput.text user interface as "2.00". If the input does not meet the requirements (input has to be between 2 and 4), the UITextField value will set the UITextField as "2.00", if the input is less than 2. "4.00", if the input is above 4.
            if let userInput = Float(gpaInput.text!){
                if(userInput >= Float(2) && userInput <= Float(4)){
                    value = userInput
                }
                else if(userInput < Float(2)){
                    value = Float(2);
                }
                else if(userInput > Float(4)){
                    value = Float(4);
                }
            }
            else{
                value = Float(2)
            }
        }
        
        //Formatting the output to %1.2f format and setting assigning it to gpaInput (UITextField)
        gpa = String(format: "%1.2f", value)
        gpaInput.text = gpa;
        gpaSelector.setValue(value, animated: true)
        
        // Get and store the program selected
        var program = "";
        if(programSelector.selectedSegmentIndex == 0){
            program = "CPA";
            if(levelSelector.selectedSegmentIndex > 2){
                levelSelector.selectedSegmentIndex = 2;
            }
            levelSelector.setEnabled(false, forSegmentAt: 3)
            levelSelector.setEnabled(false, forSegmentAt: 4)
        }
        else if(programSelector.selectedSegmentIndex == 1){
            program = "BSD";
            levelSelector.setEnabled(true, forSegmentAt: 3)
            levelSelector.setEnabled(true, forSegmentAt: 4)
        }
        
        // Get and store the level selected
        var level = "";
        level = String(levelSelector.selectedSegmentIndex + 4)
        
        // Assemble the string for the text view
        resultText.text = "I am in the " + program + " program, in level " + level + ", and my GPA is " + gpa + ".";
    }
}

