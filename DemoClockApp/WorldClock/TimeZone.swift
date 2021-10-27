//
//  TimeZone.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/4.
//

import Foundation
import UIKit
import CodableCSV

struct Zone: Codable {
    let iso2: String
    let zoneName: String
    let cityNameByCN: String
    let zoneNameByCN: String
    var countryNameByCN: String {
        return Locale(identifier: "zh_hant_TW").localizedString(forRegionCode: self.iso2) ?? self.iso2
    }
    var diff: String {
        // 時差敘述, ex: 今天 -1小時
        func dateAndTimeToInt(format: String, zoneID: String, time: Date) -> Int? {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "zh_Hant_TW")
            formatter.timeZone = TimeZone(identifier: zoneID)
            let destination = formatter.string(from: time)
            return Int(destination)
        }
        let destinationDate = dateAndTimeToInt(format: "dd", zoneID: self.zoneName, time: Date())
        let destinationTime = dateAndTimeToInt(format: "HH", zoneID: self.zoneName, time: Date())
        let systemDate = dateAndTimeToInt(format: "dd", zoneID: TimeZone.current.identifier, time: Date())
        let systemTime = dateAndTimeToInt(format: "HH", zoneID: TimeZone.current.identifier, time: Date())
        
        if let destinationDate = destinationDate,
           let destinationTime = destinationTime,
           let systemDate = systemDate,
           let systemTime = systemTime{
            let diffForHour = (destinationTime - systemTime) >= 0 ? "+\((destinationTime - systemTime))" : "\(destinationTime - systemTime)"
            if destinationDate - systemDate == 1{
                return "明天 " + diffForHour + " 小時"
            } else if destinationDate - systemDate == 0{
                return "今天 " + diffForHour + " 小時"
            } else if destinationDate - systemDate == -1{
                return "昨天 " + diffForHour + " 小時"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

extension Zone {
    // 解析csv
    static var data: [Self] {
        var array = [Self]()
        if let data = NSDataAsset(name: "zoneByCN")?.data {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
            }
            do {
                array = try decoder.decode([Self].self, from: data)
                // 中文按筆畫
                array = array.sorted(by: { $0.cityNameByCN.compare($1.cityNameByCN, locale: Locale(identifier: "zn_Hant_TW")) == .orderedAscending})
            } catch {
                print(error)
            }
        }
        return array
    }
    //
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // 自訂型別編碼後,再寫入 documentDirectory
    static func saveZone(_ timeZoneList: [Zone]) {
        // 編碼
        let encoder = JSONEncoder()
        let data = try? encoder.encode(timeZoneList)
        // 存檔
        let url = documentsDirectory.appendingPathComponent("zoneList") // 路徑
        try? data?.write(to: url) // 寫入
    }
    
    // 讀取 documentDirectory 再解碼成自訂型別
    static func loadZones() -> [Self]? { // [Self]: Self (大寫的 S) 代表型別 Zone
        // 讀取
        let url = documentsDirectory.appendingPathComponent("zoneList")
        guard let data = try? Data(contentsOf: url) else { return nil }
        // 解碼
        let decoder = JSONDecoder()
        return try? decoder.decode([Self].self, from: data)
    }
}
