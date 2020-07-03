//
//  AddViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 03/07/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        // Validation
        let title = titleTextField.text!
        let description = descriptionTextField.text!
        let tags = tagsTextField.text!
        let color = colorTextField.text!
        
        if title.isEmpty || color.isEmpty {
            displayErrorMessage(message: "Title and Color can't be blank.")
            return
        }
        

        // Get start_at and end_at
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let start = startDatePicker.date
        let end = endDatePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        let startTime = formatter.string(from: start)
        let endTime = formatter.string(from: end)
        
        // POST
        let url = "http://localhost:3000/api/activity"
        let params = [
            "title": title,
            "start_at": startTime,
            "end_at": endTime,
            "description": description,
            "tags": tags,
            "color": color            
        ]
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let json = JSON(response.value ?? ["message": "Something went wrong..."])
            if json["status"] == "OK" {
                self.displaySuccessMessage(message: json["message"].string!)
                return
            } else {
                self.displayErrorMessage(message: json["message"].string!)
                return
            }
        }
    }
    
    func displayErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: dismissAfterCreated))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissAfterCreated(alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }
}
