//
//  TimeZoneListTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/2.
//

import UIKit


class TimeZoneListTableViewController: UITableViewController {
    var timeZoneList = [
        ("台北","下午 3:17","今天 +0小時"),
        ("倫敦","上午 8:17","今天 -7小時"),
        ("紐約","上午 3:17","今天 -12小時")
    ]
//    var list = [
//        TimeZoneDetail(timeZoneName: "台北", timeDifference: 0, time: )
//    ]

    @IBOutlet weak var editButton: UIBarButtonItem!
    let timeZone = NSTimeZone.NameStyle(rawValue: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        //沒有資料的cell欄位隱藏分隔線
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
        //編輯狀態點選
//        tableView.allowsSelectionDuringEditing = true
//        tableView.allowsMultipleSelectionDuringEditing = true
        
        /*
        // 設定下拉更新功能
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        let date = Date()
        
        print(date)
        let chineseLocaleFormatter = DateFormatter()
        chineseLocaleFormatter.locale = Locale(identifier: "zh_CN")
        chineseLocaleFormatter.dateStyle = DateFormatter.Style.medium
        chineseLocaleFormatter.timeStyle = DateFormatter.Style.medium
        print(chineseLocaleFormatter.string(from: date))
        
        let usLocaleFormatter = DateFormatter()
        usLocaleFormatter.locale = Locale(identifier: "en_US")
        usLocaleFormatter.dateStyle = DateFormatter.Style.medium
        usLocaleFormatter.timeStyle = DateFormatter.Style.medium
        print(usLocaleFormatter.string(from: date) )
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.timeStyle = .full
        
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        let dateString = formatter.string(from: date)
        print(dateString)
        print(NSLocale.isoCountryCodes.count)
        print(NSTimeZone.knownTimeZoneNames.description) // "America/New_York" "Asia/Taipei" "Europe/London"
        
        print("Locale.availableIdentifiers: \(Locale.availableIdentifiers)")
        
        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        let allCities = timeZoneIdentifiers.compactMap { identifier in
            return identifier.split(separator: "/").last?.replacingOccurrences(of: "_", with: " ")
        }
        print(allCities)
        
    
    }
    
    // 畫面從其他tab頁面回來預設皆為不可編輯狀態
    override func viewWillDisappear(_ animated: Bool) {
        tableView.isEditing = false
        editButton.title = "編輯"
    }
    
    /*
    // MARK: 下拉更新
    // 自訂下拉表格更新程序
    @objc func handleRefresh(){
        // 更新的資料
        timeZoneList.append(("1", "2", "3"))
        // 停止下拉特效, 恢復表格位置
        tableView.refreshControl?.endRefreshing()
        // 重新整理資料
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 下拉更新功能產生的提示文字
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }
     */

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZoneList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimeZoneListTableViewCell.self)", for: indexPath) as? TimeZoneListTableViewCell else { return UITableViewCell()}
        let row = indexPath.row
        cell.timeDifference.text = timeZoneList[row].2
        cell.timeZone.text = timeZoneList[row].0
        cell.time.text = timeZoneList[row].1
        cell.selectionStyle = .blue
        return cell
    }
    
    // MARK: 取得點選表格
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
     */
    
    // 編輯按鈕
    @IBAction func editTimeZoneList(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "完成":"編輯"
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

//        if let selectrow = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: selectrow, animated: true)
//        }
        return indexPath
    }
    
    // MARK: 編輯 - 刪除或插入
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
    
    // 刪除或插入儲存格
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 刪除資料
            timeZoneList.remove(at: indexPath.row)
            // 刪除儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        } else if editingStyle == .none {
            tableView.allowsSelectionDuringEditing = true
        }
    }
    
    // 編輯狀態:刪除按鈕顯示的標題文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }
 
    // MARK: 編輯 - 表格順序
    // 設定哪些 row 可以排序
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
    /*
    // 左滑
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 樣式: .normal 預設灰色, .destructive 紅色
        let go = UIContextualAction(style: .normal, title: "更多") { (action, view, completionHandler) in
            // 按鈕要做的事
            print(tableView.isEditing)
            completionHandler(true)
        }
//        go.backgroundColor = .blue
       
        
        let del = UIContextualAction(style: .destructive, title: "刪除") { (action, view, completionHandler) in
            // 按鈕要做的事
            // 刪除資料
//            self.timeZoneList.remove(at: indexPath.row)
            // 刪除儲存格
//            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        // 左滑選項
        let config = UISwipeActionsConfiguration(actions: [go, del])
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    // 右滑
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let other = UIContextualAction(style: .normal, title: "其他") { (action, view, completionHandler) in
            completionHandler(true)
        }
        let config = UISwipeActionsConfiguration(actions: [other])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    */
 
    
    // MARK: 分隔線樣式
    /*
    // 分隔線間隔
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
