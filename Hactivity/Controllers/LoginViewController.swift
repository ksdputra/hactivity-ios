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

class LoginViewController: UIViewController {
    
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
        let params = ["email": "kputra@mailinator.com", "password": "123456"]
        AF.request("http://localhost:3000/api/login", method: .post, parameters: params).responseJSON { response in
            let json = JSON(response.value!)
            print(json["message"])
        }
    }
}

