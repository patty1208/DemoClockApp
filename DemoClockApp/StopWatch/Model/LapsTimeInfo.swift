//
//  LapsTimeInfo.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/8/2.
//

import Foundation

struct LapsTimeInfo {
    var lapArray: [LapTime]
    
    var maxLapTime: TimeInterval
    var minLapTime: TimeInterval
    
    var timeForFinal: TimeInterval // 目前計時的總時間:加總每次按下暫停按鈕的時間和開始按鈕的時間差
    var timeForLap: TimeInterval // 目前當圈計時的時間:目前時間和上次圈數按鈕當下的時間差
    
    var timeFromStartForFinal: Date  // 紀錄按下開始按鈕的當下時間
    var timeFromStartForLap: Date  // 紀錄按下圈數按鈕的當下時間
    
    init() {
        lapArray = []
        maxLapTime = 0
        minLapTime = TimeInterval(Int.max)
        timeForFinal = 0
        timeForLap = 0
        timeFromStartForFinal = Date()
        timeFromStartForLap = Date()
    }
    
//    var stopwatchState: StopwatchState = .Reset
//    var lapArray: [LapTime] = []
    
    
    
}
