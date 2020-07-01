//
//  ViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 30/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func passwordShowButtonPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            sender.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            sender.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // Validation
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            displayMessage(title: "Error", message: "Email and password can't be blank.")
            return
        }
        
        // Login
        let url = "http://localhost:3000/api/login"
        let params = ["email": "\(email)", "password": "\(password)"]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            let json = JSON(response.value!)
            if json["status"] == "OK" {
                KeychainWrapper.standard.set(json["message"].string!, forKey: "accessToken")
                self.performSegue(withIdentifier: "ToCalendarView", sender: self)
            } else {
                self.displayMessage(title: "Error", message: json["message"].string!)
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCalendarView" {
            _ = segue.destination as! CalendarViewController
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

