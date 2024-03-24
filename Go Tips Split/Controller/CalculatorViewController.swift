//
//  CalculatorViewController.swift
//  Go Tips Split
//
//  Created by Disha Limbani on 2024-03-17.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    var finalResult = "0.0"
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the view controller as the delegate for the text field
            billTextField.delegate = self
            
            // Set the keyboard type to decimal pad
            billTextField.keyboardType = .decimalPad
        }
   
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        billTextField.endEditing(true)
        
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        sender.isSelected = true
        
        let buttonTitle = sender.currentTitle!
        let buttonTitleMinusPercentSign =  String(buttonTitle.dropLast())
        let buttonTitleAsANumber = Double(buttonTitleMinusPercentSign)!
        tip = buttonTitleAsANumber / 100

    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        numberOfPeople = Int(sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        let bill = billTextField.text!
        if bill != "" {
            billTotal = Double(bill)!
            let result = billTotal * (1 + tip) / Double(numberOfPeople)
            finalResult = String(format: "%.2f", result)
        }
        self.performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResults" {
            
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.result = finalResult
            destinationVC.tip = Int(tip * 100)
            destinationVC.split = numberOfPeople
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension CalculatorViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Ensure that the text will be a valid decimal number after the change
            if let text = textField.text {
                // Check if the new string is empty, which is allowed
                if string.isEmpty {
                    return true
                }
                
                // Check if the new string contains only digits or a single decimal point
                let isNumeric = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
                let existingTextHasDecimalPoint = text.contains(".")
                let newTextHasDecimalPoint = string.contains(".")
                
                // Allow the change if it's a valid decimal input
                return isNumeric || (!existingTextHasDecimalPoint && newTextHasDecimalPoint)
            }
            
            return false
        
    }
}
