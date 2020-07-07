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

        // Fetch Detail
        let url = "http://localhost:3000/api/activity/\(id!)"
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        AF.request(url, headers: headers).responseJSON { response in
            let json = JSON(response.value!)
            
            // String to Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let startdate = dateFormatter.date(from: json["object"]["start_at"].string!)!
            let endDate = dateFormatter.date(from: json["object"]["end_at"].string!)!
            
            self.titleTextField.text = json["object"]["title"].string!
            self.startDatePicker.date = startdate
            self.endDatePicker.date = endDate
            self.descriptionTextField.text = json["object"]["description"].string ?? ""
            self.tagsTextField.text = json["object"]["tag_list"].string ?? ""
            self.colorTextField.text = json["object"]["color"].string ?? ""
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
