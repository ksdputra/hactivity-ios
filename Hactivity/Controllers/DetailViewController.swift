//
//  DetailViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 06/07/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    var id: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDetail()
    }
    
    func fetchDetail() {
        let url = "http://localhost:3000/api/activity/\(id!)"
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        AF.request(url, headers: headers).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 200 {
                    let json = JSON(response.value!)
                    
                    // String to Date
                    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let startdate = dateFormatter.date(from: json["object"]["start_at"].string!)!
                    let endDate = dateFormatter.date(from: json["object"]["end_at"].string!)!
                    
                    self.titleTextField.text = json["object"]["title"].string!
                    self.startDatePicker.date = startdate.addingTimeInterval(-Double(secondsFromGMT))
                    self.endDatePicker.date = endDate.addingTimeInterval(-Double(secondsFromGMT))
                    self.descriptionTextField.text = json["object"]["description"].string ?? ""
                    self.tagsTextField.text = json["object"]["tag_list"].string ?? ""
                    self.colorTextField.text = json["object"]["color"].string ?? ""
                } else {
                    self.displayErrorMessage(message: "Something went wrong...")
                    return
                }
            } else {
                self.displayErrorMessage(message: "Something went wrong...")
                return
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func displayErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: dismissAfterUpdated))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissAfterUpdated(alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UPDATE

extension DetailViewController {
    @IBAction func updateButtonPressed(_ sender: UIButton) {
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
        
        // PUT
        let url = "http://localhost:3000/api/activity/\(id!)"
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
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
}

// MARK: - DELETE

extension DetailViewController {
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let url = "http://localhost:3000/api/activity/\(id!)"
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        AF.request(url, method: .delete, headers: headers).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    self.displaySuccessMessage(message: "Activity has been deleted")
                    return
                }
            } else {
                self.displayErrorMessage(message: "Something went wrong...")
                return
            }
        }
    }
}
