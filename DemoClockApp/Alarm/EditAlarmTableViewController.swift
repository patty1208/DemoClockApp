//
//  EditAlarmTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/5.
//

import UIKit

protocol EditAlarmTableViewControllerDelegate {
    // 取消編輯頁面觸發
    func editAlarmTableViewControllerDidCancel(_ controller: EditAlarmTableViewController)
}

class EditAlarmTableViewController: UITableViewController {
    var delegate: EditAlarmTableViewControllerDelegate?
    var alarm: Alarm?
    
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var seperateCell: UITableViewCell!
    
    @IBOutlet weak var alarmTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var alarmRepeatDayLabel: UILabel!
    
    @IBOutlet weak var alarmNameLabel: UILabel!
    
    @IBOutlet weak var alarmSoundLabel: UILabel!
    
    @IBOutlet weak var alarmIsActiveSwitch: UISwitch!
    
    
    func updateUI(alarm: Alarm){
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "H:m"
        //        let time = formatter.string(from: alarm.alarmTime)
        //        alarmTimeDatePicker.setDate(time, animated: true)
        let weekNames: [week] = [.Sun,.Mon,.Tue,.Wed,.Thur,.Fri,.Sat]
        print(weekNames[3])
        var repeatDays = [week]()
        for key in weekNames {
            if alarm.repeatDays[key] == true {
                print(key)
                repeatDays.append(key) }
        }
        if repeatDays.count == 0 {
            alarmRepeatDayLabel.text = "Never"
        } else if repeatDays.count == 1 {
            alarmRepeatDayLabel.text = "Every \(repeatDays[0].rawValue)"
        } else if repeatDays.count == 7 {
            alarmRepeatDayLabel.text = "Every day"
        } else if repeatDays.count == 2 && repeatDays.contains(.Sat) && repeatDays.contains(.Sun) {
            alarmRepeatDayLabel.text = "Weekends"
        } else if repeatDays.contains(.Mon) && repeatDays.contains(.Tue) && repeatDays.contains(.Wed) && repeatDays.contains(.Thur) && repeatDays.contains(.Fri) {
            alarmRepeatDayLabel.text = "WeekDays"
        } else {
            var repeatString = ""
            for i in 0 ... repeatDays.count - 1 {
                repeatString.append("\(repeatDays[i]) ")
            }
            alarmRepeatDayLabel.text = repeatString
        }
    }
    override func viewDidLoad() {
        if let alarm = alarm { updateUI(alarm: alarm) }
        
        super.viewDidLoad()
        // 刪除鬧鐘選項
        deleteCell.isHidden = alarm == nil ? true : false
        seperateCell.isHidden = alarm == nil ? true : false
        
        // present modally 向下滑相關
        self.isModalInPresentation = false
        navigationController?.presentationController?.delegate = self
        
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView() // 不顯示沒有資料的分隔線
        tableView.allowsSelection = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 取消時返回前一頁, 鬧鐘列表頁面呈現
    @IBAction func back(_ sender: Any) {
        delegate?.editAlarmTableViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    
    // 改變時間
    @IBAction func changeTime(_ sender: UIDatePicker) {
        let date = sender.date
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.ReferenceType.system
        dateformatter.timeZone = TimeZone.ReferenceType.system
        dateformatter.dateFormat = "h:m a"
        print(dateformatter.string(from: date))
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension EditAlarmTableViewController: UIAdaptivePresentationControllerDelegate {
    // present modally 向下滑觸發
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.editAlarmTableViewControllerDidCancel(self)
    }
}

