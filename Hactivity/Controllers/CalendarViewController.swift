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
    
    @IBOutlet weak var tableView: UITableView!
    var activities = [
        Activity(id: 1, title: "Research for navigation controller", startAt: "17:00"),
        Activity(id: 2, title: "Learn Hacking With iOS part 8", startAt: "18:00")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")

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
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        cell.titleLabel.text = activities[indexPath.row].title
        cell.startAtLabel.text = activities[indexPath.row].startAt
        return cell
    }
}
