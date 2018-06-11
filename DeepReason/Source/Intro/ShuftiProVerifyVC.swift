//
//  ShuftiProVerifyVC.swift
//  DeepReason
//
//  Created by matata on 5/31/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import UIKit
import ShuftiPro

class ShuftiProVerifyVC: UIViewController {

    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    let clientIdString: String = "ddfe0e8d462af661f81db36589c39882dc0f2330785b5d80cd34f2f520ad618f" //your Client ID here
    let secretKeyString: String = "VIFKcpxTRrxytg94kFJ8tsUbzRdaDFsz" //your Secret key here
    var selectedMethod: String = ""
    var dobDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //function that put selected date into dob field
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let str = getCurrentDate(date: sender.date)
        dobField.text = str
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.date(from: str)
        dobDate = result
    }
    
    //function that gets current date
    func getCurrentDate(date: Date) ->String{
        
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    @IBAction func OnDobFieldTapped(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
        
        //datePickerView.maximumDate = NSDate() as Date
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        if dobDate != nil {
            datePickerView.date = dobDate!
        }
    }
    
    @IBAction func OnProceedClicked(_ sender: Any) {
        selectedMethod = "id_card"
        let varify = Shuftipro(clientId: clientIdString, secretKey: secretKeyString, parentVC: self)
        varify.documentVerification(method: selectedMethod, firstName: fnameField.text!, lastName: lnameField.text!, dob: dobField.text!, country: countryCodeField.text!, phoneNumber: phoneField.text!){
            (result: Any) in
            
            let reponse = result as! NSDictionary
            if reponse.value(forKey: "status_code") as! String == "SP1" {
                print("Verified")
            }else{
                //print(reponse.value(forKey: "message") as! String)
                print(result)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
