//
//  EditAlarmLabelTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/7.
//

import UIKit

class EditAlarmLabelTableViewController: UITableViewController {
    var alarmName: String
    init?(coder: NSCoder, alarmLabel: String){
        self.alarmName = alarmLabel
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var labelTextField: UITextField!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.labelTextField.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/5))
        tableView.tableFooterView = UIView() // 不顯示沒有資料的分隔線
        labelTextField.text = alarmName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            performSegue(withIdentifier: "unwindToEditAlarmFromLabel", sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 不顯示灰色section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let text = labelTextField.text {
            alarmName = text == "" ? "Alarm" : text
        }
    }
}

