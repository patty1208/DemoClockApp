//
//  Alarm.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/5.
//

import Foundation

struct Alarm: Codable {
    let alarmID: String
    var alarmTime: String
    var repeatDays: [Week:Bool]
    var alarmLabel: String
    var alarmSound: Sound
    var alarmSnooze: Bool
    var alarmIsActive: Bool
    var alarmRepeatDaysDescription: String {
        let weekNames: [Week] = [.Mon,.Tue,.Wed,.Thu,.Fri,.Sat,.Sun]
        var repeatDays = [Week]()
        for key in weekNames{
            if self.repeatDays[key] == true {
                repeatDays.append(key)
            }
        }
        if repeatDays.count == 0 {
            return "Never"
        } else if repeatDays.count == 1 {
            return "Every \(repeatDays[0].rawValue)"
        } else if repeatDays.count == 7 {
            return "Every day"
        } else if repeatDays.count == 2 && repeatDays.contains(.Sat) && repeatDays.contains(.Sun) {
            return "Weekends"
        } else if repeatDays.contains(.Mon) && repeatDays.contains(.Tue) && repeatDays.contains(.Wed) && repeatDays.contains(.Thu) && repeatDays.contains(.Fri) {
            return "WeekDays"
        } else {
            var repeatString = ""
            for i in 0 ... repeatDays.count - 1 {
                repeatString.append("\(repeatDays[i]) ")
            }
            return repeatString
        }
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static func saveAlarm(_ alarms: [Alarm]) {
        // 編碼
        let encoder = JSONEncoder()
        let data = try? encoder.encode(alarms)
        // 存檔
        let url = documentsDirectory.appendingPathComponent("alarm") // 路徑
        try? data?.write(to: url) // 寫入
    }
    
    // 讀取 documentDirectory 再解碼成自訂型別
    static func loadAlarms() -> [Self]? { // [Self]: Self (大寫的 S) 代表型別 Alarm
        // 讀取
        let url = documentsDirectory.appendingPathComponent("alarm")
        guard let data = try? Data(contentsOf: url) else { return nil }
        // 解碼
        let decoder = JSONDecoder()
        return try? decoder.decode([Self].self, from: data)
    }
}
enum Week: String, CaseIterable, Codable {
    case Sun = "Sunday"
    case Mon = "Monday"
    case Tue = "Tuesday"
    case Wed = "Wednesday"
    case Thu = "Thursday"
    case Fri = "Friday"
    case Sat = "Saturday"
}


