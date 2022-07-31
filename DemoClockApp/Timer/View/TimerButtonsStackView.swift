//
//  TimerButtonsStackView.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/7/31.
//

import UIKit

class TimerButtonsStackView: UIStackView {

    // 開始和取消button
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            if #available(iOS 15, *){
                cancelButton.configurationUpdateHandler = {
                    button in
                    let alpha = button.isHighlighted ? 0.4 : 0.8
                    button.configuration?.background.backgroundColor = button.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha) : UIColor.getCustomBlueColor(alpha: 0.2)
                    button.configuration?.attributedTitle?.foregroundColor = button.isEnabled ? .darkGray : .systemGray4
                }
            } else {
                cancelButton.layer.cornerRadius = cancelButton.bounds.width / 2
                cancelButton.layer.borderWidth = 3
                
                let alpha = cancelButton.isHighlighted ? 0.4 : 0.8
                cancelButton.layer.borderColor = cancelButton.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha).cgColor : UIColor.getCustomBlueColor(alpha: 0.2).cgColor
                cancelButton.setTitleColor(.darkGray, for: .normal)
                cancelButton.setTitleColor(.systemGray4, for: .disabled)
            }
        }
    }
    @IBOutlet weak var startPauseResumeButton: UIButton! {
        didSet {
            if #available(iOS 15, *) {
            } else {
                startPauseResumeButton.layer.cornerRadius = startPauseResumeButton.bounds.width / 2
                startPauseResumeButton.layer.borderWidth = 3
            }
        }
    }
}


