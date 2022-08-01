//
//  HeaderView.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/8/1.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var headerLapNumberLabel: UILabel!{
        didSet {
            headerLapNumberLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  headerLapNumberLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    @IBOutlet weak var headerLapTimeLabel: UILabel!{
        didSet {
            headerLapTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  headerLapTimeLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    @IBOutlet weak var headerSeperateView: UIView!

}
