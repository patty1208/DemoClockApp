//
//  EditAlarmSoundTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/7.
//

import UIKit

class EditAlarmSoundTableViewController: UITableViewController {
    
    let soundList = AlarmSoundList.allCases
    var alarmSound: AlarmSoundList
    var selectIndex: Int
    
    init?(coder: NSCoder, alarmSound: AlarmSoundList){
        self.alarmSound = alarmSound
        self.selectIndex = soundList.firstIndex(of: alarmSound) ?? 0
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            performSegue(withIdentifier: "unwindToEditAlarmFromSound", sender: self)
        }
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SoundTableViewCell.self)", for: indexPath) as? SoundTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        cell.soundLabel.text = soundList[row].rawValue
        if row == selectIndex {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: IndexPath(row: selectIndex, section: 0))?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndex = indexPath.row
        alarmSound = soundList[selectIndex]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        alarmSound
//    }
    

}
