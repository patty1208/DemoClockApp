//
//  StopWatchViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit

class StopWatchViewController: UIViewController {
    // color
    let redCustomColor = UIColor(red: 240/255, green: 173/255, blue: 161/255, alpha: 1)
    let darkredCustomColor = UIColor(red: 169/255, green: 36/255, blue: 21/255, alpha: 1)
    let greenCustomColor = UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: 1)
    let darkgreenCustomColor = UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
    let blueCustomColor = UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 1)
    
    @IBOutlet weak var finalTimeLabel: UILabel!{
        didSet {
            finalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  finalTimeLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startOrStopButton: UIButton!{
        didSet {
            if #available(iOS 15, *){
            startOrStopButton.configurationUpdateHandler = {
                button in
                let alpha = button.isHighlighted ? 0.4 : 0.8
                button.configuration?.background.backgroundColor = self.state == "Stop" ? UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha) : UIColor(red: 240/255, green: 173/255, blue: 161/255, alpha: alpha)
                button.configuration?.attributedTitle?.foregroundColor = self.state == "Stop" ? self.darkgreenCustomColor : self.darkredCustomColor
                }
            } else {
                startOrStopButton.layer.cornerRadius = startOrStopButton.bounds.width/2
                let alpha = startOrStopButton.isHighlighted ? 0.4 : 0.8
                startOrStopButton.layer.backgroundColor = self.state == "Stop" ? UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha).cgColor : UIColor(red: 240/255, green: 173/255, blue: 161/255, alpha: alpha).cgColor
            }
        }
    }
    @IBOutlet weak var lapOrResetButton: UIButton!{
        didSet {
            if #available(iOS 15, *){
                lapOrResetButton.configurationUpdateHandler = {
                    button in
                    let alpha = button.isHighlighted ? 0.4 : 0.8
                    button.configuration?.background.backgroundColor = button.isEnabled ? UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha) : UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 0.2)
                    button.configuration?.attributedTitle?.foregroundColor = button.isEnabled == true ? .darkGray : .systemGray4
                }
            } else {
                lapOrResetButton.layer.cornerRadius = lapOrResetButton.bounds.width/2
                let alpha = lapOrResetButton.isHighlighted ? 0.4 : 0.8
                lapOrResetButton.layer.backgroundColor = lapOrResetButton.isEnabled ? UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha).cgColor : UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 0.2).cgColor
            }
        }
    }
    
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
    
    var state = "Stop" {
        didSet {
            startOrStopButton.setTitle(self.state == "Start" ? "Stop" : "Start", for: .normal)
            lapOrResetButton.setTitle(self.state == "Start" ? "Lap" : "Reset", for: .normal)
        
            
            if #available(iOS 15, *){
                lapOrResetButton.configurationUpdateHandler = {
                    button in
                    let alpha = button.isHighlighted ? 0.4 : 0.8
                    button.configuration?.background.backgroundColor = button.isEnabled ? UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha) : UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 0.2)
                    button.configuration?.attributedTitle?.foregroundColor = button.isEnabled == true ? .darkGray : .systemGray4
                }
            } else {
                lapOrResetButton.layer.cornerRadius = lapOrResetButton.bounds.width/2
                let alpha = lapOrResetButton.isHighlighted ? 0.4 : 0.8
                lapOrResetButton.layer.backgroundColor = lapOrResetButton.isEnabled ? UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha).cgColor : UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 0.2).cgColor
                lapOrResetButton.setTitleColor(lapOrResetButton.isEnabled == true ? .darkGray : .systemGray4, for: .normal)
            }
            
            if #available(iOS 15, *){
            startOrStopButton.configurationUpdateHandler = {
                button in
                let alpha = button.isHighlighted ? 0.4 : 0.8
                button.configuration?.background.backgroundColor = self.state == "Stop" ? UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha) : UIColor(red: 240/255, green: 173/255, blue: 161/255, alpha: alpha)
                button.configuration?.attributedTitle?.foregroundColor = self.state == "Stop" ? self.darkgreenCustomColor : self.darkredCustomColor
                }
            } else {
                startOrStopButton.layer.cornerRadius = startOrStopButton.bounds.width/2
                let alpha = startOrStopButton.isHighlighted ? 0.4 : 0.8
                startOrStopButton.layer.backgroundColor = self.state == "Stop" ? UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha).cgColor : UIColor(red: 240/255, green: 173/255, blue: 161/255, alpha: alpha).cgColor
                startOrStopButton.setTitleColor(state == "Stop" ? darkgreenCustomColor : self.darkredCustomColor, for: .normal)
            }
            
        }
    }
    var timerForFinal: Timer = Timer(){
        didSet{
            RunLoop.current.add(timerForFinal, forMode: .common)
        }
    }
    var timerForLap: Timer = Timer(){
        didSet{
            RunLoop.current.add(timerForLap, forMode: .common)
        }
    }
    var timeFromStartForFinal = Date()
    var timeFromStartForLap = Date()
    var timeForFinal: TimeInterval = 0
    var timeForLap: TimeInterval = 0.0
    var showRunningLapTimeString = ""
    var maxLapTime: TimeInterval = 0.0
    var minLapTime: TimeInterval = TimeInterval(Int.max)
    var lapArray: [LapTime] = []
    
    @objc func timerActionForTotal() {
        let timeFromEnd = Date()
        let showTime = timeForFinal + timeFromEnd.timeIntervalSince(timeFromStartForFinal)
        if #available(iOS 15, *){
            let minutes = Int(showTime/60).formatted(.number.precision(.integerLength(2)))
            let seconds = (Int(showTime) % 60).formatted(.number.precision(.integerLength(2)))
            let hundredsOfSeconds = (Int(showTime * 100) % 100).formatted(.number.precision(.integerLength(2)))
            finalTimeLabel.text = "\(minutes):\(seconds).\(hundredsOfSeconds)"
        } else {
            let minutes = String(format: "%02d", Int(showTime / 60))
            let seconds = String(format: "%02d", Int(showTime) % 60)
            let hundredsOfSeconds = String(format: "%02d", Int(showTime * 100) % 100)
            finalTimeLabel.text = "\(minutes):\(seconds).\(hundredsOfSeconds)"
        }
    }
    @objc func timerActionForLap() {
        let timeFromEnd = Date()
        let showTime = timeForLap + timeFromEnd.timeIntervalSince(timeFromStartForLap)
        if #available(iOS 15, *){
            let minutes = Int(showTime/60).formatted(.number.precision(.integerLength(2)))
            let seconds = (Int(showTime) % 60).formatted(.number.precision(.integerLength(2)))
            let hundredsOfSeconds = (Int(showTime * 100) % 100) .formatted(.number.precision(.integerLength(2)))
            showRunningLapTimeString = "\(minutes):\(seconds).\(hundredsOfSeconds)"
            headerLapTimeLabel.text = showRunningLapTimeString
            headerLapNumberLabel.text = "Lap \(lapArray.count + 1)"
        } else {
            let minutes = String(format: "%02d", Int(showTime / 60))
            let seconds = String(format: "%02d", Int(showTime) % 60)
            let hundredsOfSeconds = String(format: "%02d", Int(showTime * 100) % 100)
            showRunningLapTimeString = "\(minutes):\(seconds).\(hundredsOfSeconds)"
            headerLapTimeLabel.text = showRunningLapTimeString
            headerLapNumberLabel.text = "Lap \(lapArray.count + 1)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        lapOrResetButton.isEnabled = false
        headerLapNumberLabel.text = ""
        headerLapTimeLabel.text = ""
    }
    
    @IBAction func tapStartOrStop(_ sender: UIButton) {
        state = state == "Stop" ? "Start" : "Stop"
        lapOrResetButton.isEnabled = true
        headerSeperateView.isHidden = false
        if state == "Start" {
            timeFromStartForFinal = Date()
            timerForFinal = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForTotal), userInfo: nil, repeats: true)
            timeFromStartForLap = Date()
            timerForLap = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForLap), userInfo: nil, repeats: true)
        } else if state == "Stop" {
            timeForFinal = timeForFinal + Date().timeIntervalSince(timeFromStartForFinal)
            timerForFinal.invalidate()
            timeForLap = timeForLap + Date().timeIntervalSince(timeFromStartForLap)
            timerForLap.invalidate()
        }
    }
    
//    @available( iOS 15,*)
    @IBAction func tapLapOrReset(_ sender: UIButton) {
        if state == "Start" {
            timeForLap = timeForLap + Date().timeIntervalSince(timeFromStartForLap)
            timeForLap = Double(String(format: "%.4f", timeForLap)) ?? timeForLap // 不想要位數過多,想要先四捨五入,再比大小
            
            // 顯示 lap time 字串
            let showTime = timeForLap
            var showTimeString = ""
            if #available(iOS 15, *){
                let minutes = Int(showTime/60).formatted(.number.precision(.integerLength(2)))
                let seconds = (Int(showTime) % 60).formatted(.number.precision(.integerLength(2)))
                let hundredsOfSeconds = (Int(showTime * 100) % 100) .formatted(.number.precision(.integerLength(2)))
                showTimeString = "\(minutes):\(seconds).\(hundredsOfSeconds)"
            } else {
                let minutes = String(format: "%02d", Int(showTime / 60))
                let seconds = String(format: "%02d", Int(showTime) % 60)
                let hundredsOfSeconds = String(format: "%02d", Int(showTime * 100) % 100)
                showTimeString = "\(minutes):\(seconds).\(hundredsOfSeconds)"
            }
            
            // 更新最大最小值的 lap
            maxLapTime =  timeForLap > maxLapTime ? timeForLap : maxLapTime
            minLapTime = timeForLap < minLapTime ? timeForLap : minLapTime
            
            // lap list 更新
            lapArray.insert(LapTime(lapNumber: lapArray.count + 1, lapTimeForString: showTimeString, laptime: timeForLap), at: 0)
            tableView.reloadData()
            // lap 重新計時
            timerForLap.invalidate()
            timeFromStartForLap = Date()
            timeForLap = 0
            timerForLap = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForLap), userInfo: nil, repeats: true)
            
//            RunLoop.current.add(timerForLap, forMode: .common)
        } else if state == "Stop"{
            // 初始化 timer 所需
            timeForFinal = 0
            timeForLap = 0
            maxLapTime = 0
            minLapTime = Double(Int.max)
            
            // 更新 lap list
            lapArray = []
            tableView.reloadData()
            headerSeperateView.isHidden = true
            headerLapTimeLabel.text = ""
            headerLapNumberLabel.text = ""
            
            // 更新 final time
            finalTimeLabel.text = "00:00.00"
            
            // 更新 button 狀態
            lapOrResetButton.isEnabled = false
            lapOrResetButton.setTitle("Lap", for: .normal)
        
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension StopWatchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(StopwatchTableViewCell.self)", for: indexPath) as? StopwatchTableViewCell else { return UITableViewCell() }
        
        let lapInfo = lapArray[indexPath.row]
        cell.lap.text = "Lap \(lapInfo.lapNumber)"
        cell.time.text = lapInfo.lapTimeForString
        if lapArray.count >= 2 {
            // 有超過兩筆以上判斷 最長lap:紅色,最短lap:綠色
            if lapInfo.laptime >= maxLapTime {
                cell.lap.textColor = UIColor(red: 169/255, green: 36/255, blue: 21/255, alpha: 1)
                cell.time.textColor = UIColor(red: 169/255, green: 36/255, blue: 21/255, alpha: 1)
            } else if lapInfo.laptime <= minLapTime{
                cell.lap.textColor = UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
                cell.time.textColor = UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
            } else {
                cell.lap.textColor = UIColor.darkText
                cell.time.textColor = UIColor.darkText
            }
        }
        return cell
    }
}


