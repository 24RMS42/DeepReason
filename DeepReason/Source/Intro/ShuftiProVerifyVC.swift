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

    let clientIdString: String = "ddfe0e8d462af661f81db36589c39882dc0f2330785b5d80cd34f2f520ad618f" //your Client ID here
    let secretKeyString: String = "VIFKcpxTRrxytg94kFJ8tsUbzRdaDFsz" //your Secret key here
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnProceedClicked(_ sender: Any) {
        let varify = Shuftipro(clientId: clientIdString, secretKey: secretKeyString, parentVC: self)
        varify.creditCardVerification(country: "countryField.text!", cardFirst6Digits: "cardSixDigits.text!", cardLast4Digits: "card4Digits.text!", phoneNumber: "phoneField.text!"){
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
