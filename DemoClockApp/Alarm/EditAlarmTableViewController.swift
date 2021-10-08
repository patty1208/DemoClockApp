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
    let formatter = DateFormatter()
    @IBOutlet weak var alarmTimeDatePicker: UIDatePicker!
    @IBOutlet weak var alarmRepeatDayLabel: UILabel!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmSoundLabel: UILabel!
    @IBOutlet weak var alarmIsSnoozeSwitch: UISwitch!
    @IBOutlet weak var seperateCell: UITableViewCell!
    @IBOutlet weak var deleteCell: UITableViewCell!
    func updateUI(alarm: Alarm?){
        formatter.dateFormat = "HH:mm"
        alarmTimeDatePicker.date = formatter.date(from: alarm?.alarmTime ?? "") ?? Date()
        alarmRepeatDayLabel.text = alarm?.alarmRepeatDaysDescription ?? "Never"
        alarmNameLabel.text = alarm?.alarmLabel ?? "Alarm"
        alarmSoundLabel.text = alarm?.alarmSound.rawValue ?? AlarmSoundList.allCases[0].rawValue
        alarmIsSnoozeSwitch.isOn = alarm?.alarmSnooze ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 編輯頁面:目的 - 新增 alarm = nil / 修改 alarm != nil
        seperateCell.isHidden = alarm == nil ? true : false
        deleteCell.isHidden = alarm == nil ? true : false
        title = alarm == nil ? "新增鬧鐘" : "編輯鬧鐘"
        alarm = alarm ?? Alarm(alarmTime: formatter.string(from: Date()), repeatDays: [.Sun:false,.Mon:false,.Tue:false,.Wed:false,.Thur:false,.Fri:false,.Sat:false], alarmLabel: "Alarm", alarmSound: AlarmSoundList.allCases[0], alarmSnooze: true, alarmIsActive: true)
        updateUI(alarm: alarm)
        
        // present modally 向下滑相關
        self.isModalInPresentation = false
        navigationController?.presentationController?.delegate = self
        
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
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
        alarm?.alarmTime = formatter.string(from: alarmTimeDatePicker.date)
    }
    @IBSegueAction func passRepeatDays(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditAlarmRepeatDayTableViewController? {
        let repeatDays: [Week: Bool] = alarm?.repeatDays ?? [.Sun:false,.Mon:false,.Tue:false,.Wed:false,.Thur:false,.Fri:false,.Sat:false]
        return EditAlarmRepeatDayTableViewController(coder: coder, repeatDays: repeatDays)
    }
    @IBSegueAction func passLabelName(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditAlarmLabelTableViewController? {
        let alarmLabel = alarm?.alarmLabel ?? "Alarm"
        return EditAlarmLabelTableViewController(coder: coder, alarmLabel: alarmLabel)
    }
    @IBSegueAction func passSound(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditAlarmSoundTableViewController? {
        let sound = alarm?.alarmSound ?? AlarmSoundList.allCases[0]
        return EditAlarmSoundTableViewController(coder: coder, alarmSound: sound)
    }
    @IBAction func turnAlarmIsSnoozeSwitch(_ sender: UISwitch) {
        alarm?.alarmSnooze = sender.isOn
    }
    
    @IBAction func unwindToEditAlarm(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier ==
            "unwindToEditAlarmFromRepeatDays" {
            if let sourceViewController = unwindSegue.source as? EditAlarmRepeatDayTableViewController {
                alarm?.repeatDays = sourceViewController.repeatDays
            }
        } else if unwindSegue.identifier == "unwindToEditAlarmFromLabel" {
            if let sourceViewController = unwindSegue.source as? EditAlarmLabelTableViewController {
                alarm?.alarmLabel = sourceViewController.alarmName
            }
        } else if unwindSegue.identifier == "unwindToEditAlarmFromSound" {
            if let sourceViewController = unwindSegue.source as? EditAlarmSoundTableViewController {
                alarm?.alarmSound = sourceViewController.alarmSound
            }
        }
        updateUI(alarm: alarm)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAlarmTableViewControllerFromSave"{
            alarm = Alarm(alarmTime: formatter.string(from: alarmTimeDatePicker.date), repeatDays: alarm?.repeatDays ?? [.Sun:false,.Mon:false,.Tue:false,.Wed:false,.Thur:false,.Fri:false,.Sat:false], alarmLabel: alarmNameLabel.text ?? "Alarm" , alarmSound: alarm?.alarmSound ?? AlarmSoundList.Rader, alarmSnooze: alarmIsSnoozeSwitch.isOn, alarmIsActive: alarm?.alarmIsActive ?? true)
        }
    }
}

extension EditAlarmTableViewController: UIAdaptivePresentationControllerDelegate {
    // present modally 向下滑觸發
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.editAlarmTableViewControllerDidCancel(self)
    }
}

