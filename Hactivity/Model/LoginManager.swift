//
//  LoginManager.swift
//  Hactivity
//
//  Created by Kharisma Putra on 30/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

struct LoginManager {
    let url = "http://localhost:3000/api/login"
    
    mutating func call(email: String, password: String) {
        let params = ["email": "\(email)", "password": "\(password)"]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            let json = JSON(response.value!)
            if json["status"] == "OK" {
                KeychainWrapper.standard.set(json["message"].string!, forKey: "accessToken")
//                KeychainWrapper.standard.removeObject(forKey: "accessToken")
                print("Success")
            } else {
                print("Error")
            }
                
        }
    }
    
    
}
