//
//  TimeZoneListTableViewCell.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/2.
//

import UIKit


class TimeZoneListTableViewCell: UITableViewCell {
    @IBOutlet weak var timeDifference: UILabel!
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
