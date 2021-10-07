//
//  EditAlarmRepeatDayTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/7.
//

import UIKit

class EditAlarmRepeatDayTableViewController: UITableViewController {
    let week = Week.allCases
    var repeatDays: [Week:Bool]
    init?(coder:NSCoder, repeatDays: [Week:Bool]){
        self.repeatDays = repeatDays
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            performSegue(withIdentifier: "unwindToEditAlarmFromRepeatDays", sender: self)
        }
     }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatDayTableViewCell", for: indexPath) as? RepeatDayTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        let weekName = week[row]
        cell.weekLabel.text = "Every \(week[row].rawValue)"
        cell.accessoryType = repeatDays[weekName]! ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        repeatDays[week[row]] = !repeatDays[week[row]]!
        tableView.cellForRow(at: indexPath)?.accessoryType = repeatDays[week[row]]! ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     // MARK: - Navigation
    
}
