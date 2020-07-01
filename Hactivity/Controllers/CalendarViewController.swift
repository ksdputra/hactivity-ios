//
//  CalendarViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 30/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        if accessToken == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        print(accessToken)
    }

}
