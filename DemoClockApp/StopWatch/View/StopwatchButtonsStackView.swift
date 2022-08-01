//
//  StopwatchButtonsStackView.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/8/1.
//

import UIKit

class StopwatchButtonsStackView: UIStackView {

    @IBOutlet weak var startOrStopButton: UIButton!{
        didSet {
            if #available(iOS 15, *){
            } else {
                startOrStopButton.layer.cornerRadius = startOrStopButton.bounds.width/2
            }
        }
    }
    
    @IBOutlet weak var lapOrResetButton: UIButton!{
        didSet {
            if #available(iOS 15, *){
                lapOrResetButton.configurationUpdateHandler = {
                    button in
                    let alpha = button.isHighlighted ? 0.4 : 0.8
                    button.configuration?.background.backgroundColor = button.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha) : UIColor.getCustomBlueColor(alpha: 0.2)
                    button.configuration?.attributedTitle?.foregroundColor = button.isEnabled == true ? .darkGray : .systemGray4
                }
            } else {
                lapOrResetButton.layer.cornerRadius = lapOrResetButton.bounds.width/2
                let alpha = lapOrResetButton.isHighlighted ? 0.4 : 0.8
                lapOrResetButton.layer.backgroundColor = lapOrResetButton.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha).cgColor : UIColor.getCustomBlueColor(alpha: 0.2).cgColor
            }
        }
    }

}
