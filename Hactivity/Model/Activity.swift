//
//  Activity.swift
//  Hactivity
//
//  Created by Kharisma Putra on 02/07/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct Activity {
    let id: Int
    let title: String
    let startAt: String
    
    init(id: Int, title: String, startAt: String) {
        self.id = id
        self.title = title
        self.startAt = startAt
    }
    
    func getStartAt() -> String {
        // String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: startAt)!

        // Date to string
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let startTime = formatter.string(from: date)
        return startTime
    }
}
