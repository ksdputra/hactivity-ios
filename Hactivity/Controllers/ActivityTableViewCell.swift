//
//  ActivityTableViewCell.swift
//  Hactivity
//
//  Created by Kharisma Putra on 02/07/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = #colorLiteral(red: 1, green: 0.8897035122, blue: 0.87011832, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
