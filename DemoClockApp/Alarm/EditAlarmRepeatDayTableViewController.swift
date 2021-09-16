//
//  EditAlarmRepeatDayTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/7.
//

import UIKit

class EditAlarmRepeatDayTableViewController: UITableViewController {
    let week: [week] = [.Sun,.Mon,.Tue,.Wed,.Thur,.Fri,.Sat]
    var repeatDays: [week:Bool] = [.Sun:true,.Mon:false,.Tue:false,.Wed:false,.Thur:false,.Fri:true,.Sat:true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 100
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
        repeatDays[week[indexPath.row]] = !repeatDays[week[indexPath.row]]!
        tableView.cellForRow(at: indexPath)?.accessoryType = repeatDays[week[indexPath.row]]! ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
