//
//  AlarmTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit
import UserNotifications

class AlarmTableViewController: UITableViewController {
    
    var alarmList = [Alarm]() {
        didSet {
            alarmList = alarmList.sorted { $0.alarmTime < $1.alarmTime }
            Alarm.saveAlarm(alarmList)
        }
    }
    @IBOutlet weak var editAlarmButton: UIBarButtonItem!
    
    func updateTableViewUIByEditStatus(editStatus: Bool){
        if editStatus == false {
            tableView.isEditing = false
            editAlarmButton.title = "編輯"
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let alarmList = Alarm.loadAlarms(){
            self.alarmList = alarmList
        }
        // tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
    }
    
    
    // 畫面從其他tab頁面回來預設皆為不可編輯狀態
    override func viewWillDisappear(_ animated: Bool) {
        updateTableViewUIByEditStatus(editStatus: false)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AlarmTableViewCell.self)", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell()}
        let row = indexPath.row
        let alarm = alarmList[row]
        cell.alarmTime.text = "\(alarm.alarmTime)"
        cell.alarmNameAndRepeatDays.text = "\(alarm.alarmLabel), \(alarm.alarmRepeatDaysDescription)"
        cell.alarmSwitch.isOn = alarm.alarmIsActive
        cell.alarmSwitch.isHidden = tableView.isEditing ? true : false // 編輯時則隱藏開關
        cell.editingAccessoryType = .disclosureIndicator
        cell.delegate = self
        return cell
    }
    // 鬧鐘列表:編輯狀態(編輯/完成)
    @IBAction func editAlarmList(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: false)
        sender.title = tableView.isEditing ? "完成" : "編輯"
        tableView.reloadData()
    }
    
    // MARK: 編輯 - 刪除
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 刪除資料
            alarmList.remove(at: indexPath.row)
            // 刪除儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    @IBSegueAction func editAlarm(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditAlarmTableViewController? {
        guard let controller = EditAlarmTableViewController(coder: coder) else { return nil }
        controller.delegate = self
        // 修改鬧鐘,傳目前鬧鐘資訊至下頁
        guard let row = tableView.indexPathForSelectedRow?.row else { return controller }
        controller.alarm = alarmList[row]
        return controller
    }
    
    func notificationFromAlarm(alarm: Alarm){
        let content = UNMutableNotificationContent()
        content.body = "\(alarm.alarmLabel)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: alarm.alarmSound.soundFileFullName))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: alarm.alarmTime) else { return }
        
        if alarm.alarmIsActive == true {
            if Array(alarm.repeatDays.values) == Array(repeating: false, count: 7){
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "Notification For Only Day From Alarm \(alarm.alarmID)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    print("成功建立推播通知 id: \(request.identifier)")
                })
                
            } else {
                // 刪除推播
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Notification For Only Day From Alarm \(alarm.alarmID)"])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Notification For Only Day From Alarm \(alarm.alarmID)"])
            }
            for i in Week.allCases {
                let calendar = Calendar.current
                var components = calendar.dateComponents([.weekday, .hour, .minute], from: date)
                if alarm.repeatDays[i] == true {
                    components.weekday = Week.allCases.firstIndex(of: i)! + 1
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    let request = UNNotificationRequest(identifier: "Notification For Repeat Every \(i) From Alarm \(alarm.alarmID)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                        print("成功建立推播通知 id: \(request.identifier)")
                    })
                } else {
                    // 刪除推播
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Notification For Repeat Every \(i) From Alarm \(alarm.alarmID)"])
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Notification For Repeat Every \(i) From Alarm \(alarm.alarmID)"])
                }
            }
        }
        
    }
    
    @IBAction func unwindToAlarmTableViewController(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? EditAlarmTableViewController,
           let alarm = sourceViewController.alarm {
            if unwindSegue.identifier == "unwindToAlarmTableViewControllerFromSave" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    alarmList[indexPath.row] = alarm
                    tableView.reloadRows(at: [indexPath], with: .none)
                } else {
                    alarmList.insert(alarm, at: 0)
                    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                
            } else if unwindSegue.identifier == "unwindToAlarmTableViewControllerFromDelete"{
                if let indexPath = tableView.indexPathForSelectedRow {
                    alarmList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            updateTableViewUIByEditStatus(editStatus: false)
            notificationFromAlarm(alarm: alarm)
        }
    }
}

extension AlarmTableViewController: EditAlarmTableViewControllerDelegate {
    // 在編輯頁面按取消或頁面下滑取消而回到鬧鐘列表頁面, 觸發使鬧鐘列表頁面呈現不可編輯狀態
    func editAlarmTableViewControllerDidCancel(_ controller: EditAlarmTableViewController) {
        updateTableViewUIByEditStatus(editStatus: false)
    }
}
extension AlarmTableViewController: AlarmTableViewCellTapDelegate{
    func isActiveSwitch(cell: AlarmTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        alarmList[indexPath.row].alarmIsActive = !alarmList[indexPath.row].alarmIsActive
        tableView.reloadRows(at: [indexPath], with: .automatic)
        notificationFromAlarm(alarm: alarmList[indexPath.row])
    }
}
