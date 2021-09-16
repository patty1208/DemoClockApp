//
//  Alarm.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/5.
//

import Foundation

struct Alarm {
    var alarmTime: String
    var repeatDays: [week:Bool]
    var alarmLabel: String
    var alarmSound: String
    var alarmSnooze: Bool
    var alarmIsActive: Bool
    
}
enum week: String {
    case Mon = "Monday"
    case Tue = "Tuesday"
    case Wed = "Wednesday"
    case Thur = "Thursday"
    case Fri = "Friday"
    case Sat = "Saturday"
    case Sun = "Sunday"
}

enum alartSound {
    case Rader, Apex, Uplift
}

