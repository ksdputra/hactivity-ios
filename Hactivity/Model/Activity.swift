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
}
