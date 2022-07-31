//
//  StopWatchTableViewCell.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit

class StopwatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lap: UILabel!{
        didSet {
            lap.font = UIFont.monospacedDigitSystemFont(ofSize:  lap!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    @IBOutlet weak var time: UILabel!{
        didSet {
            time.font = UIFont.monospacedDigitSystemFont(ofSize:  time!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
