//
//  TimerViewController.swift
//  TimerViewController
//
//  Created by 林佩柔 on 2021/9/16.
//

import UIKit
import UserNotifications

enum State: String {
    case Start, Pause, Resume, Cancel
}
class TimerViewController: UIViewController {
    
    // pickerview
    @IBOutlet weak var containPickerView: UIView!
    @IBOutlet weak var countdownTimePickerView: UIPickerView!
    var demoStringLabel1: UILabel = UILabel()
    var demoStringLabel2: UILabel = UILabel()
    var demoStringLabel3: UILabel = UILabel()
    
    // 開始和取消button
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            if #available(iOS 15, *){
            cancelButton.configurationUpdateHandler = {
                button in
                let alpha = button.isHighlighted ? 0.4 : 0.8
                button.configuration?.background.backgroundColor = button.isEnabled ? UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha) : UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 0.2)
                button.configuration?.baseForegroundColor = button.isEnabled == true ? .darkGray : .systemGray4
            }
            }}
    }
    @IBOutlet weak var startPauseResumeButton: UIButton! {
        didSet {
            if #available(iOS 15, *){
            startPauseResumeButton.configurationUpdateHandler = {
                button in
                let alpha = button.isHighlighted ? 0.4 : 0.8
                if self.startPauseResumeButton.isEnabled == true {
                    // 開始和繼續時:橘色,暫停和取消:綠色
                    button.configuration?.background.backgroundColor = ["Start","Resume"].contains(self.state) ? UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: alpha) : UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha)
                    button.configuration?.baseForegroundColor = ["Start","Resume"].contains(self.state) ? UIColor(red: 168/255, green: 77/255, blue: 25/255, alpha: 1) : UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
                } else {
                    button.configuration?.background.backgroundColor = UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: 0.2)
                    button.configuration?.baseForegroundColor = UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
                }
            }
            }}
    }
    var state = "Cancel" {
        didSet {
            if state == "Start"{
                startPauseResumeButton.setTitle("Pause", for: .normal)
            } else if state == "Pause" {
                startPauseResumeButton.setTitle("Resume", for: .normal)
            } else if state == "Resume" {
                startPauseResumeButton.setTitle("Pause", for: .normal)
            } else if state == "Cancel" {
                startPauseResumeButton.setTitle("Start", for: .normal)
            }
        }
    }
    
    // 鈴聲
    @IBOutlet weak var ringtonesLabel: UILabel!
//    var ringtone: RingtonesList? = RingtonesList.allCases[0]
    var ringtone: Sound? = Sound.data[0]
    
    // 倒數計時器畫面
    @IBOutlet weak var countdownLabel: UILabel!{
        didSet {
            countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  countdownLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    var timer: Timer = Timer()
    
    
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
    
    // 更新鈴聲標籤文字畫面
    func updateTimerRingtoneUI(){
        ringtonesLabel.text = ringtone?.soundName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerRingtoneUI() //鈴聲標籤文字
        customPickerViewUI(stringArray: [" hours"," min","  sec"], customPickerview: countdownTimePickerView) // pickerview畫面
        selectPickerViewRows(hour: 10, min: 0, sec: 0) // 初始位置
    }
    // timer結束的推播
    func timerFinishNotification() {
        let content = UNMutableNotificationContent()
        content.body = "計時器"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: ringtone?.soundFileFullName ?? Sound.data[0].soundFileFullName))
        let request = UNNotificationRequest(identifier: "notificationByTimer", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
    @objc func timerAction() {
        let formatter = DateFormatter()
        if var text = self.countdownLabel.text {
            
            // 當時間為00:00跳回原畫面
            if text == "00:00" {
                self.containPickerView.isHidden = false
                self.timer.invalidate()
                // 跳通知
                print("倒數結束")
                self.state = "Cancel"
                self.cancelButton.isEnabled = false
                self.timerFinishNotification()
                
            }
            
            formatter.dateFormat = text.count <= 5 ? "mm:ss" : "HH:mm:ss"
            // 文字轉時間
            guard var time = formatter.date(from: text) else { return }
            
            time = time - TimeInterval(1)
            
            // 時間轉文字
            text = formatter.string(from: time)
            self.countdownLabel.text = text
        }
    }
    @IBAction func tapStartPauseResumeButton(_ sender: UIButton) {
        containPickerView.isHidden = true
        cancelButton.isEnabled = true
        if state == "Cancel" {
            state = "Start"
        } else if state == "Start" {
            state = "Pause"
        } else if state == "Pause" {
            state = "Resume"
        } else if state == "Resume"{
            state = "Pause"
        }
        if state == "Start" || state == "Resume" {
            if state == "Start"{
                updateCountdownLabelFromPickerView()
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else if state == "Pause" {
            timer.invalidate()
        }
        
    }
    @IBAction func tapCancelButton(_ sender: UIButton) {
        state = "Cancel"
        containPickerView.isHidden = false
        cancelButton.isEnabled = false
        timer.invalidate()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 將文字限定在cell的左1/3,然後保持向右對齊
        let rowSize = countdownTimePickerView.rowSize(forComponent: 0)
        let pickerview = UIView(frame: CGRect(x: 0, y: 0, width: rowSize.width, height: rowSize.height))
        let pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rowSize.width/3, height: rowSize.height))
        pickerLabel.text = row.description
        pickerLabel.textAlignment = .right
        pickerview.addSubview(pickerLabel)
        return pickerview
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 避免滑動過快偵測選取和畫面選取的不同
        countdownTimePickerView.selectRow(row, inComponent: component, animated: false)
        
        // 皆是0,開始的button不能使用
        if countdownTimePickerView.selectedRow(inComponent: 0) == 0 && countdownTimePickerView.selectedRow(inComponent: 1) == 0 && countdownTimePickerView.selectedRow(inComponent: 2) == 0 {
            startPauseResumeButton.isEnabled = false
        } else {
            startPauseResumeButton.isEnabled = true
        }
        // 更新倒數計時器標籤
        updateCountdownLabelFromPickerView()
    }
    func selectPickerViewRows(hour: Int, min: Int, sec: Int) {
        // pickerView的初始位置
        pickerView(countdownTimePickerView, didSelectRow: hour, inComponent: 0)
        pickerView(countdownTimePickerView, didSelectRow: min, inComponent: 1)
        pickerView(countdownTimePickerView, didSelectRow: sec, inComponent: 2)
    }
    func updateCountdownLabelFromPickerView(){
        // 依pickerview選取更新countdownLabel
        let hour = countdownTimePickerView.selectedRow(inComponent: 0)
        let min = countdownTimePickerView.selectedRow(inComponent: 1)
        let sec = countdownTimePickerView.selectedRow(inComponent: 2)
        // 時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = hour == 0 ? "mm:ss" : "HH:mm:ss"
        // 文字轉時間
        var text = hour == 0 ? "\(min):\(sec)" : "\(hour):\(min):\(sec)"
        guard let time = formatter.date(from: text) else { return }
        // 時間轉文字
        text = formatter.string(from: time)
        countdownLabel.text = text
    }
}
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
