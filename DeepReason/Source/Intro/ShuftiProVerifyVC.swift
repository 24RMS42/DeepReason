//
//  ShuftiProVerifyVC.swift
//  DeepReason
//
//  Created by matata on 5/31/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import UIKit
import ShuftiPro
import CountryPickerView
import SCLAlertView

class ShuftiProVerifyVC: UIViewController {

    @IBOutlet weak var verifySelectionBtn: UIButton!
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    let clientIdString: String = "a0f8b2c4cb1ac82abdb37f0fe5203b97be556c4468c83bba18684d620fd8eaf9" //your Client ID here
    let secretKeyString: String = "c1N4YfTX4oyrV7Nj3I9wMNpnlJsW6Mtj" //your Secret key here
    var selectedMethod: String = "id_card"
    var dobDate: Date? = nil
    var cpv = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //make background of navigation bar transparent
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        //ISO country code
        cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        countryCodeField.leftView = cpv
        countryCodeField.leftViewMode = .always
        cpv.showPhoneCodeInView = false
        cpv.showCountryCodeInView = false
        cpv.setCountryByCode("US")
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
    
    func goToLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Intro", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "master")
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func isValid() -> Bool {
        if ((fnameField.text?.isEmpty)! || (lnameField.text?.isEmpty)! || (dobField.text?.isEmpty)!) {
            SCLAlertView().showWarning("Please fill out all fields", subTitle: "")
            return false
        }
        return true
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
        if !isValid() {
            return
        }
        let isoCountryCodeName = cpv.selectedCountry.code
        let varify = Shuftipro(clientId: clientIdString, secretKey: secretKeyString, parentVC: self)
        varify.documentVerification(method: selectedMethod, firstName: fnameField.text!, lastName: lnameField.text!, dob: dobField.text!, country: isoCountryCodeName, phoneNumber: phoneField.text!){
            (result: Any) in
            
            let reponse = result as! NSDictionary
            if reponse.value(forKey: "status_code") as! String == "SP1" {
                print("Verified")
                self.goToLogin()
            }else{
                //print(reponse.value(forKey: "message") as! String)
                print(result)
            }
        }
    }
    
    @IBAction func OnCancelClicked(_ sender: Any) {
        self.goToLogin()
    }
    
    @IBAction func OnVerifySelectionClicked(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let idCardAction = UIAlertAction(title: "ID Card Verification", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectedMethod = "id_card"
            self.verifySelectionBtn.setTitle("ID Card Verification", for: UIControlState.normal)
        })
        let drivingLicenseAction = UIAlertAction(title: "Driving Licence Verification", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectedMethod = "driving_license"
            self.verifySelectionBtn.setTitle("Driving Licence Verification", for: UIControlState.normal)
        })
        let passportAction = UIAlertAction(title: "Passport Verification", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectedMethod = "passport"
            self.verifySelectionBtn.setTitle("Passport Verification", for: UIControlState.normal)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(idCardAction)
        optionMenu.addAction(drivingLicenseAction)
        optionMenu.addAction(passportAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
