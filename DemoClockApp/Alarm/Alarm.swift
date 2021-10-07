//
//  Alarm.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/5.
//

import Foundation

struct Alarm {
    var alarmTime: String
    var repeatDays: [Week:Bool]
    var alarmLabel: String
    var alarmSound: AlarmSoundList
    var alarmSnooze: Bool
    var alarmIsActive: Bool
    var alarmRepeatDaysDescription: String {
        let weekNames: [Week] = [.Mon,.Tue,.Wed,.Thur,.Fri,.Sat,.Sun]
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
        } else if repeatDays.contains(.Mon) && repeatDays.contains(.Tue) && repeatDays.contains(.Wed) && repeatDays.contains(.Thur) && repeatDays.contains(.Fri) {
            return "WeekDays"
        } else {
            var repeatString = ""
            for i in 0 ... repeatDays.count - 1 {
                repeatString.append("\(repeatDays[i]) ")
            }
            return repeatString
        }
    }
}
enum Week: String, CaseIterable {
    case Sun = "Sunday"
    case Mon = "Monday"
    case Tue = "Tuesday"
    case Wed = "Wednesday"
    case Thur = "Thursday"
    case Fri = "Friday"
    case Sat = "Saturday"
}

enum AlarmSoundList: String, CaseIterable{
    case Rader, Apex, Uplift
}

