//
//  CalendarViewController.swift
//  Hactivity
//
//  Created by Kharisma Putra on 30/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FSCalendar
import Alamofire
import SwiftyJSON

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var activities = [Activity]()
    var activityID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        
        
        let currentDate = Date()
        let tomorrowDate  = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)

        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        let startDate = formatter.string(from: currentDate)
        let endDate = formatter.string(from: tomorrowDate!)
        fetchIndex(from: startDate, to: endDate)
//        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
//        if accessToken == nil {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        self.dismiss(animated: true, completion: nil)
        
//        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = rootVC
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ToAddView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            let vc = segue.destination as! DetailViewController
            vc.id = activityID
        }
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        cell.titleLabel.text = activities[indexPath.row].title
        cell.startAtLabel.text = activities[indexPath.row].getStartAt()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityID = activities[indexPath.row].id
        self.performSegue(withIdentifier: "ToDetailView", sender: self)
    }
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Get next date
        let endDateRaw = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        // Formatting date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: date)
        let endDate = formatter.string(from: endDateRaw!)
        
        // Fetch index
        fetchIndex(from: startDate, to: endDate)
    }
    
    func fetchIndex(from startDate: String, to endDate: String) {
        let url = "http://localhost:3000/api/activity"
        let params = ["from_date": startDate, "to_date": endDate]
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        AF.request(url, parameters: params, headers: headers).responseJSON { response in
            let json = JSON(response.value ?? ["message": "Something went wrong..."])
            
            self.activities = []
            var counter: Int
            if json["object"].count <= 0 {
                counter = 0
            } else {
                counter = json["object"].count
                for i in 0...(counter - 1) {
                    let object = json["object"][i]
                    let activity = Activity(id: object["id"].int!, title: object["title"].string!, startAt: object["start_at"].string!)
                    self.activities.append(activity)
                }
            }
            
            self.tableView.reloadData()
        }
    }
}
