//
//  CityTableViewCell.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/10/22.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
