//
//  SignupViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 30/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
        // Validation
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if name.isEmpty || email.isEmpty || password.isEmpty {
            displayMessage(title: "Error", message: "Name, Email, and Password can't be blank.")
            return
        }
        
        // Signup
        let url = "http://localhost:3000/api/user"
        let params = ["name": name,"email": email, "password": password]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            let json = JSON(response.value ?? ["message": "Something went wrong..."])
            if json["status"] == "OK" {
                self.displayMessage(title: "Success", message: json["message"].string!)
                return
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

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
}
