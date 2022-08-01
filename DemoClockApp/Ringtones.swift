//
//  Ringtones.swift
//  Ringtones
//
//  Created by 林佩柔 on 2021/10/11.
//

import Foundation
import UIKit
import CodableCSV

struct Sound: Codable, Equatable {
    var soundFileFullName: String
    var soundFile: String
    var sounfFileExtension: String
    var soundName: String
}

extension Sound {
    static var data: [Self] {
        var array = [Self]()
        if let data = NSDataAsset(name: "ringtones")?.data {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine // 第一行為欄位名稱
            }
            do {
                array = try decoder.decode([Self].self, from: data)
            } catch {
                print(error)
            }
        }
        return array
    }
}
