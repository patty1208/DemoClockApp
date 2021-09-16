//
//  AlarmTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    var alarmList = [Alarm]()
    @IBOutlet weak var editAlarmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmList = [Alarm(alarmTime: "8:30", repeatDays:[.Sun:true,.Mon:false,.Tue:false,.Wed:false,.Thur:false,.Fri:false,.Sat:false], alarmLabel: "起床", alarmSound: "Uplift", alarmSnooze: true, alarmIsActive: true)]
        
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // 畫面從其他tab頁面回來預設皆為不可編輯狀態
    override func viewWillDisappear(_ animated: Bool) {
        tableView.isEditing = false
        editAlarmButton.title = "編輯"
        tableView.reloadData()
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
        cell.alarmName.text = alarmList[row].alarmLabel
        cell.alarmTime.text = "\(alarmList[row].alarmTime)"
        cell.alarmSwitch.isOn = alarmList[row].alarmIsActive
        cell.alarmSwitch.isHidden = tableView.isEditing ? true : false // edit 則隱藏 switch 開關
        cell.editingAccessoryType = .disclosureIndicator
        return cell
    }
    // 鬧鐘列表:編輯狀態(編輯/完成)
    @IBAction func editTimeZoneList(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.reloadData()
        sender.title = tableView.isEditing ? "完成" : "編輯"
    }
    
    // MARK: 編輯 - 刪除或插入
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
        } else if editingStyle == .insert {
        }    
    }

    // MARK: - Navigation
   
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destination as? UINavigationController
        let editAlarmTableViewController = navigationController?.viewControllers[0] as? EditAlarmTableViewController
        editAlarmTableViewController?.delegate = self
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        editAlarmTableViewController?.alarm = alarmList[row]
    }
    
    /*
     @IBSegueAction func editAlarm(_ coder: NSCoder) -> UINavigationController? {
     let navigationController = UINavigationController() as? UINavigationController
     let editAlarmTableViewController = navigationController?.viewControllers[0] as? EditAlarmTableViewController
     editAlarmTableViewController?.delegate = self
     return navigationController
     }
     */
    
    
    @IBAction func unwindToAlarmTableView(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? EditAlarmTableViewController {
            print("")
        }
        // Use data from the view controller which initiated the unwind segue
    }
}

extension AlarmTableViewController: EditAlarmTableViewControllerDelegate {
    // 在編輯頁面按取消或頁面下滑取消而回到鬧鐘列表頁面, 觸發使鬧鐘列表頁面呈現不可編輯狀態
    func editAlarmTableViewControllerDidCancel(_ controller: EditAlarmTableViewController) {
        tableView.isEditing = false
        editAlarmButton.title = "編輯"
        tableView.reloadData()
    }
}
