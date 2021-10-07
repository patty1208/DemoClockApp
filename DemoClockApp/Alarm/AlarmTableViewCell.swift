//
//  AlarmTableViewCell.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit

protocol AlarmTableViewCellTapDelegate {
    func isActiveSwitch(cell: AlarmTableViewCell)
}


class AlarmTableViewCell: UITableViewCell {
    var delegate: AlarmTableViewCellTapDelegate?
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmNameAndRepeatDays: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func turnAlarmIsActiveSwitch(_ sender: UISwitch) {
        delegate?.isActiveSwitch(cell: self)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
}
