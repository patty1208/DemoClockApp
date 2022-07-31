//
//  TimerView.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/7/30.
//  計時器 pickerview 和倒數計時的數字顯示

import UIKit

class TimerView: UIView {
    
    @IBOutlet weak var containPickerView: UIView!
    @IBOutlet weak var countdownTimePickerView: UIPickerView!
    var demoStringLabel1: UILabel = UILabel()
    var demoStringLabel2: UILabel = UILabel()
    var demoStringLabel3: UILabel = UILabel()
    
    // 倒數計時器畫面
    @IBOutlet weak var countdownLabel: UILabel!{
        didSet {
            countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  countdownLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    
    // pickerview 中間加固定位置的文字
    func customPickerViewUI(stringArray: [String], customPickerview: UIPickerView) {
        // pickerview 中間加固定位置的文字
        let rowSize = customPickerview.rowSize(forComponent: 0) // pickerView的cell大小
        let borderOfPickerview = (customPickerview.frame.width - rowSize.width * 3) / 3 // pickerView除了cell的單位長度(pickerview左右外圍各一單位中間加總一單位)
        //        customPickerview.layer.backgroundColor = UIColor.gray.cgColor
        //        customPickerview.backgroundColor = UIColor.darkGray
        
        demoStringLabel1.frame = CGRect(x: customPickerview.bounds.midX - rowSize.width/2 - rowSize.width * (2/3) - borderOfPickerview * (1/2), y: customPickerview.bounds.midY - (rowSize.height / 2), width: rowSize.width, height: rowSize.height)
        
        demoStringLabel2.frame = CGRect(x: customPickerview.bounds.midX - rowSize.width/2 + rowSize.width * (1/3), y: customPickerview.bounds.midY - (rowSize.height / 2), width: rowSize.width, height: rowSize.height)
        
        demoStringLabel3.frame = CGRect(x: customPickerview.bounds.midX + rowSize.width/2 + rowSize.width * (1/3) + borderOfPickerview * (1/2), y: customPickerview.bounds.midY - (rowSize.height / 2), width: rowSize.width, height: rowSize.height)
        
        demoStringLabel1.text = stringArray[0]
        demoStringLabel1.textAlignment = .left
        
        demoStringLabel2.text = stringArray[1]
        demoStringLabel2.textAlignment = .left
        
        demoStringLabel3.text = stringArray[2]
        demoStringLabel3.textAlignment = .left
        
        customPickerview.addSubview(demoStringLabel1)
        customPickerview.addSubview(demoStringLabel2)
        customPickerview.addSubview(demoStringLabel3)
    }
}
