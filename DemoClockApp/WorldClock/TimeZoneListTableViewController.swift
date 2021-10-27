//
//  TimeZoneListTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/2.
//

import UIKit

class TimeZoneListTableViewController: UITableViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    var timerForUpdateTime = Timer()
    var timeZoneList = [Zone](){
        didSet {
            Zone.saveZone(timeZoneList)
        }
    }
    
    @objc func updateTime(){
        self.tableView.reloadData()
    }
    
    func updateTableViewUIByEditStatus(editStatus: Bool){
        if editStatus == false {
            tableView.setEditing(false, animated: true)
            editButton.title = "編輯"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "完成"
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        //沒有資料的cell欄位隱藏分隔線
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 讀取 zone
        if let zoneList = Zone.loadZones(){
            self.timeZoneList = zoneList
        }
        
        // 每分鐘更新tableView內容
        timerForUpdateTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // 畫面從其他tab頁面回來預設皆為不可編輯狀態
    override func viewWillDisappear(_ animated: Bool) {
        updateTableViewUIByEditStatus(editStatus: false)
    }
    
    // 離開畫面停止更新時間
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timerForUpdateTime.invalidate()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return timeZoneList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimeZoneListTableViewCell.self)", for: indexPath) as? TimeZoneListTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        let zone = timeZoneList[row]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: zone.zoneName)
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "a hh:mm"
        
        cell.timeDifference.text = "\(zone.diff)"
        cell.timeZone.text = zone.cityNameByCN
        cell.time.text = formatter.string(from: Date())
        cell.time.isHidden = tableView.isEditing ? true : false
        
        return cell
    }
    
    // MARK: 編輯 - 刪除
    // 設定哪些 row 可以編輯
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 編輯狀態下,設定樣式是否可以使用刪除或插入
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    // 編輯狀態, style = .none 左邊不往內縮
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // 刪除儲存格
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 刪除資料
            timeZoneList.remove(at: indexPath.row)
            // 刪除儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 編輯狀態:滑動刪除按鈕顯示的標題文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }
    
    // MARK: 編輯 - 移動表格順序
    // 設定哪些 row 可以移動排序
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 更新資料的順序
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        timeZoneList.insert(timeZoneList.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    // MARK: 表格 swipe 左滑右滑功能
    // 開始滑動時
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editButton.title = "完成"
    }
    // 滑動取消或選擇按鈕後
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editButton.title = "編輯"
    }
    
    // 編輯按鈕
    @IBAction func editTimeZoneList(_ sender: UIBarButtonItem) {
        updateTableViewUIByEditStatus(editStatus: !tableView.isEditing)
    }
    
    
    
    // MARK: - Navigation
    // 指定addWorldClock的delegate是self
    @IBSegueAction func addWorldClock(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> AddWorldClockTableViewController? {
        guard let controller = AddWorldClockTableViewController(coder: coder) else { return nil }
        controller.delegate = self
        return controller
    }
    // 傳回來選擇地區的時區資料
    @IBAction func unwindToTimeZoneList(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? AddWorldClockTableViewController,
           let selectedZone = sourceViewController.selectedZone {
            timeZoneList.append(selectedZone)
            tableView.reloadData()
        }
        updateTableViewUIByEditStatus(editStatus: false)
    }
}

extension TimeZoneListTableViewController: AddWorldClockTableViewControllerDelegate {
    // 在新增世界時鐘頁面下滑而回到時區列表頁面, 觸發使時區列表頁面呈現不可編輯狀態
    func addWorldClockTableViewControllerDidCancel(_ controller: AddWorldClockTableViewController) {
        updateTableViewUIByEditStatus(editStatus: false)
    }
}
