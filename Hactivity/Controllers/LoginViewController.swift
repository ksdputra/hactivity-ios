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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
            let json = JSON(response.value ?? ["message": "Something went wrong..."])
            if json["status"] == "OK" {
                KeychainWrapper.standard.set(json["message"].string!, forKey: "accessToken")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
//                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = rootVC
            } else {
                self.displayMessage(title: "Error", message: json["message"].string!)
                return
            }
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

