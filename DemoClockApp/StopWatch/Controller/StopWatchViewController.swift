//
//  StopWatchViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/9/3.
//

import UIKit

class StopWatchViewController: UIViewController {
    @IBOutlet weak var finalTimeLabel: UILabel!{
        didSet {
            finalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize:  finalTimeLabel!.font.pointSize, weight: UIFont.Weight.light)
        }
    }
    @IBOutlet weak var stopwatchButtonsStackView: StopwatchButtonsStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    var state = "Stop" {
        didSet {
            stopwatchButtonsStackView.startOrStopButton.setTitle(self.state == "Start" ? "Stop" : "Start", for: .normal)
            stopwatchButtonsStackView.lapOrResetButton.setTitle(self.state == "Start" ? "Lap" : "Reset", for: .normal)
        
            
            if #available(iOS 15, *){
                stopwatchButtonsStackView.lapOrResetButton.configurationUpdateHandler = {
                    button in
                    let alpha = button.isHighlighted ? 0.4 : 0.8
                    button.configuration?.background.backgroundColor = button.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha) : UIColor.getCustomBlueColor(alpha: 0.2)
                    button.configuration?.attributedTitle?.foregroundColor = button.isEnabled == true ? .darkGray : .systemGray4
                }
            } else {
                stopwatchButtonsStackView.lapOrResetButton.layer.cornerRadius = stopwatchButtonsStackView.lapOrResetButton.bounds.width/2
                let alpha = stopwatchButtonsStackView.lapOrResetButton.isHighlighted ? 0.4 : 0.8
                stopwatchButtonsStackView.lapOrResetButton.layer.backgroundColor = stopwatchButtonsStackView.lapOrResetButton.isEnabled ? UIColor.getCustomBlueColor(alpha: alpha).cgColor : UIColor.getCustomBlueColor(alpha: 0.2).cgColor
                stopwatchButtonsStackView.lapOrResetButton.setTitleColor(stopwatchButtonsStackView.lapOrResetButton.isEnabled == true ? .darkGray : .systemGray4, for: .normal)
            }
            
            if #available(iOS 15, *){
            stopwatchButtonsStackView.startOrStopButton.configurationUpdateHandler = {
                button in
                let alpha = button.isHighlighted ? 0.4 : 0.8
                button.configuration?.background.backgroundColor = self.state == "Stop" ? UIColor.getCustomGreenColor(alpha: alpha) : UIColor.getRedColor(alpha: alpha)
                button.configuration?.attributedTitle?.foregroundColor = self.state == "Stop" ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor()
                }
            } else {
                stopwatchButtonsStackView.startOrStopButton.layer.cornerRadius = stopwatchButtonsStackView.startOrStopButton.bounds.width/2
                let alpha = stopwatchButtonsStackView.startOrStopButton.isHighlighted ? 0.4 : 0.8
                stopwatchButtonsStackView.startOrStopButton.layer.backgroundColor = self.state == "Stop" ? UIColor.getCustomGreenColor(alpha: alpha).cgColor : UIColor.getRedColor(alpha: alpha).cgColor
                stopwatchButtonsStackView.startOrStopButton.setTitleColor(state == "Stop" ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor(), for: .normal)
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
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自動推算 row 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        stopwatchButtonsStackView.lapOrResetButton.isEnabled = false
        headerView.headerLapNumberLabel.text = ""
        headerView.headerLapTimeLabel.text = ""
    }
    
    // MARK: - Timer
    @objc func timerActionForTotal() {
        let timeFromEnd = Date()
        let showTime = timeForFinal + timeFromEnd.timeIntervalSince(timeFromStartForFinal)
        finalTimeLabel.text = stringFromTimeInterval(interval: showTime)
    }
    @objc func timerActionForLap() {
        let timeFromEnd = Date()
        let showTime = timeForLap + timeFromEnd.timeIntervalSince(timeFromStartForLap)
        headerView.headerLapTimeLabel.text = stringFromTimeInterval(interval: showTime)
        headerView.headerLapNumberLabel.text = "Lap \(lapArray.count + 1)"
    }
    
    // MARK: - UI
    func updateUI() {
        
        // update button UI
        stopwatchButtonsStackView.startOrStopButton.setTitle(self.state == "Start" ? "Stop" : "Start", for: .normal)
        stopwatchButtonsStackView.lapOrResetButton.setTitle(self.state == "Start" ? "Lap" : "Reset", for: .normal)
        
        if #available(iOS 15, *){
        stopwatchButtonsStackView.startOrStopButton.configurationUpdateHandler = {
            button in
            let alpha = button.isHighlighted ? 0.4 : 0.8
            button.configuration?.background.backgroundColor = self.state == "Stop" ? UIColor.getCustomGreenColor(alpha: alpha) : UIColor.getRedColor(alpha: alpha)
            button.configuration?.attributedTitle?.foregroundColor = self.state == "Stop" ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor()
            }
        } else {
            let alpha = stopwatchButtonsStackView.startOrStopButton.isHighlighted ? 0.4 : 0.8
            stopwatchButtonsStackView.startOrStopButton.layer.backgroundColor = self.state == "Stop" ? UIColor.getCustomGreenColor(alpha: alpha).cgColor : UIColor.getRedColor(alpha: alpha).cgColor
            stopwatchButtonsStackView.startOrStopButton.setTitleColor(state == "Stop" ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor(), for: .normal)
        }
    }
        
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let time = NSInteger(interval * 100)
        let hundredsOfSeconds = time % 100
        let seconds = (time / 100) % 60
        let minutes = (time / 6000) % 60
        return String(NSString(format: "%0.2d:%0.2d:%0.2d",minutes,seconds,hundredsOfSeconds))
     }
    
    //MARK: - button action
    @IBAction func tapStartOrStop(_ sender: UIButton) {
        state = state == "Stop" ? "Start" : "Stop"
        stopwatchButtonsStackView.lapOrResetButton.isEnabled = true
        headerView.headerSeperateView.isHidden = false
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
            
            // 更新最大最小值的 lap
            maxLapTime =  timeForLap > maxLapTime ? timeForLap : maxLapTime
            minLapTime = timeForLap < minLapTime ? timeForLap : minLapTime
            
            // lap list 更新
            lapArray.insert(LapTime(lapNumber: lapArray.count + 1, lapTimeForString: stringFromTimeInterval(interval: timeForLap), laptime: timeForLap), at: 0)
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
            headerView.headerSeperateView.isHidden = true
            headerView.headerLapTimeLabel.text = ""
            headerView.headerLapNumberLabel.text = ""
            
            // 更新 final time
            finalTimeLabel.text = "00:00.00"
            
            // 更新 button 狀態
            stopwatchButtonsStackView.lapOrResetButton.isEnabled = false
            stopwatchButtonsStackView.lapOrResetButton.setTitle("Lap", for: .normal)
        
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
                cell.lap.textColor = UIColor.getDarkRedColor()
                cell.time.textColor = UIColor.getDarkRedColor()
            } else if lapInfo.laptime <= minLapTime{
                cell.lap.textColor = UIColor.getDarkGreenColor()
                cell.time.textColor = UIColor.getDarkGreenColor()
            } else {
                cell.lap.textColor = UIColor.darkText
                cell.time.textColor = UIColor.darkText
            }
        }
        return cell
    }
}


