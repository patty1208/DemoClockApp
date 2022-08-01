//
//  SoundTableViewCell.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/7.
//  計時器 Timer 選擇鈴聲

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
