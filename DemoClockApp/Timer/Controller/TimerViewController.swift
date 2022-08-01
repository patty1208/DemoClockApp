//
//  TimerViewController.swift
//  TimerViewController
//
//  Created by 林佩柔 on 2021/9/16.
//  計時器

import UIKit
import UserNotifications

class TimerViewController: UIViewController {
    @IBOutlet weak var timerView: TimerView! {
        didSet {
            timerView.customPickerViewUI(stringArray: [" 小時"," 分鐘","  秒"], customPickerview: timerView.countdownTimePickerView)
        }
    }
    @IBOutlet weak var timerButtonsStackView: TimerButtonsStackView!
    // 鈴聲
    @IBOutlet weak var ringtonesLabel: UILabel!
    
    var timer: Timer = Timer()
    var state = State.Cancel
    var countdownInterval: TimeInterval = 0 // 倒數秒數
    var ringtone: Sound? = Sound.data[0]
    //    var ringtone: RingtonesList? = RingtonesList.allCases[0]
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerRingtoneUI() //鈴聲標籤文字
        selectPickerViewRows(hour: 0, min: 25, sec: 0) // 初始位置
        updateUI(state: state)
    }
    
    // MARK: - update UI
    // 更新鈴聲標籤文字畫面
    func updateTimerRingtoneUI(){
        ringtonesLabel.text = ringtone?.soundName
    }
    
    // 更新按鈕UI依 state
    func updateUI(state: State){
        timerView.containPickerView.isHidden = state == .Cancel ? false : true
        timerButtonsStackView.cancelButton.isEnabled = state == .Cancel ? false : true
        let title: State
        switch state {
        case .Start:
            title = .Pause
        case .Pause:
            title = .Resume
        case .Resume:
            title = .Pause
        case .Cancel:
            title = .Start
        }
        timerButtonsStackView.startPauseResumeButton.setTitle(title.rawValue, for: .normal)

        if #available(iOS 15, *){
            timerButtonsStackView.startPauseResumeButton.configurationUpdateHandler = {
                button in
                // 計時器皆是 0 時 不能使用: 綠色但背景透明度 0.2
                // 狀態開始和繼續時:橘色, 暫停和取消:綠色
                let alpha: CGFloat = button.isEnabled ? button.isHighlighted ? 0.4 : 0.8 : 0.2
                button.configuration?.background.backgroundColor = [State.Start, State.Resume].contains(state) ? UIColor.getOrangeColor(alpha: alpha) : UIColor.getCustomGreenColor(alpha: alpha)
                button.configuration?.attributedTitle?.foregroundColor = [State.Start, State.Resume].contains(state) ? UIColor.getDarkOrangeColor() : UIColor.getDarkGreenColor()
            }
        } else {
            // 計時器皆是 0 時 不能使用: 綠色但背景透明度 0.2
            // 狀態開始和繼續時:橘色, 暫停和取消:綠色
            guard let button = timerButtonsStackView.startPauseResumeButton else { return }
            let alpha = button.isEnabled ? button.isHighlighted ? 0.4 : 0.8 : 0.2
            // 開始和繼續時:橘色,暫停和取消:綠色
            button.layer.borderColor = [State.Start, State.Resume].contains(state) ? UIColor.getOrangeColor(alpha: alpha).cgColor : UIColor.getCustomGreenColor(alpha: alpha).cgColor
            button.setTitleColor([State.Start, State.Resume].contains(state) ? UIColor.getDarkOrangeColor() : UIColor.getDarkGreenColor(), for: .normal)
            button.setTitleColor(UIColor.getDarkGreenColor(), for: .disabled)
        }
    }
    
    // MARK: - timer
    @objc func timerAction() {
        countdownInterval -= 1
        if countdownInterval == -1 {
            self.timer.invalidate()
            // 跳通知
            print("倒數結束")
            self.state = State.Cancel
            self.timerFinishNotification()
            updateUI(state: state)
        } else {
            self.timerView.countdownLabel.text = String(stringFromTimeInterval(interval: countdownInterval))
        }
    }
    
    // timer結束的本地推播通知
    func timerFinishNotification() {
        let content = UNMutableNotificationContent()
        content.body = "計時器"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: ringtone?.soundFileFullName ?? Sound.data[0].soundFileFullName))
        let request = UNNotificationRequest(identifier: "notificationByTimer", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let time = NSInteger(interval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return hours == 0 ? NSString(format: "%0.2d:%0.2d",minutes,seconds) : NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
     }
    
    
    // MARK: - button action
    @IBAction func tapStartPauseResumeButton(_ sender: UIButton) {
        switch state {
        case .Start:
            state = .Pause
        case .Pause:
            state = .Resume
        case .Resume:
            state = .Pause
        case .Cancel:
            state = .Start
        }
        if state == .Start || state == .Resume {
            if state == .Start {
                updateCountdownLabelFromPickerView()
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else if state == .Pause {
            timer.invalidate()
        }
        updateUI(state: state)
    }
    @IBAction func tapCancelButton(_ sender: UIButton) {
        state = .Cancel
        timer.invalidate()
        updateUI(state: state)
    }
    
    
    
     // MARK: - Navigation
    @IBSegueAction func passSound(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditTimerSoundTableViewController? {
        let sound = ringtone ?? Sound.data[0]
        return EditTimerSoundTableViewController(coder: coder, ringtone: sound)
    }
    
    @IBAction func unwindToTimerVC(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier ==
            "unwindToTimerFromSound" {
            if let sourceViewController = unwindSegue.source as? EditTimerSoundTableViewController {
                ringtone = sourceViewController.ringtone
            }
        }
        updateTimerRingtoneUI()
    }
}

extension TimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    // MARK: - UIPickerViewDelegate
    func selectPickerViewRows(hour: Int, min: Int, sec: Int) {
        // pickerView的初始位置
        pickerView(timerView.countdownTimePickerView, didSelectRow: hour, inComponent: 0)
        pickerView(timerView.countdownTimePickerView, didSelectRow: min, inComponent: 1)
        pickerView(timerView.countdownTimePickerView, didSelectRow: sec, inComponent: 2)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 將文字限定在cell的左1/3,然後保持向右對齊
        let rowSize = timerView.countdownTimePickerView.rowSize(forComponent: 0)
        let pickerview = UIView(frame: CGRect(x: 0, y: 0, width: rowSize.width, height: rowSize.height))
        let pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rowSize.width/3, height: rowSize.height))
        pickerLabel.text = row.description
        pickerLabel.textAlignment = .right
        pickerview.addSubview(pickerLabel)
        return pickerview
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 避免滑動過快偵測選取和畫面選取的不同
        timerView.countdownTimePickerView.selectRow(row, inComponent: component, animated: false)
        
        // 皆是0,開始的button不能使用
        if timerView.countdownTimePickerView.selectedRow(inComponent: 0) == 0 && timerView.countdownTimePickerView.selectedRow(inComponent: 1) == 0 && timerView.countdownTimePickerView.selectedRow(inComponent: 2) == 0 {
            timerButtonsStackView.startPauseResumeButton.isEnabled = false
        } else {
            timerButtonsStackView.startPauseResumeButton.isEnabled = true
        }
        // 更新倒數計時器標籤
        updateCountdownLabelFromPickerView()
    }
    // MARK: - pickerView
    func updateCountdownLabelFromPickerView(){
        // 依 pickerview 選取更新倒數計時 countdownInterval 和更新 countdownLabel
        let hour = timerView.countdownTimePickerView.selectedRow(inComponent: 0)
        let min = timerView.countdownTimePickerView.selectedRow(inComponent: 1)
        let sec = timerView.countdownTimePickerView.selectedRow(inComponent: 2)
        countdownInterval = TimeInterval(hour * 60 * 60 + min * 60 + sec)
        timerView.countdownLabel.text = String(stringFromTimeInterval(interval: countdownInterval))
    }
}
// 沒用到
extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.right
                
                self.addSubview(label)
            }
        }
    }
}
