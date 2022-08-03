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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // 自動推算 row 高度
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var headerView: HeaderView!
    
    var stopwatchState: StopwatchState = .Reset
    var lapsTimeInfo = LapsTimeInfo()
    
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
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Timer
    @objc func timerActionForTotal() {
        finalTimeLabel.text = stringFromTimeInterval(interval: lapsTimeInfo.timeForFinal + Date().timeIntervalSince(lapsTimeInfo.timeFromStartForFinal))
    }
    
    @objc func timerActionForLap() {
        headerView.headerLapTimeLabel.text = stringFromTimeInterval(interval: lapsTimeInfo.timeForLap + Date().timeIntervalSince(lapsTimeInfo.timeFromStartForLap))
    }
    
    // MARK: - UI
    func updateUI() {
        if stopwatchState == .Reset {
            finalTimeLabel.text = stringFromTimeInterval(interval: lapsTimeInfo.timeForFinal)
            headerView.headerLapNumberLabel.text = ""
            headerView.headerLapTimeLabel.text = ""
        } else if stopwatchState == .Start || stopwatchState == .Resume {
            headerView.headerLapNumberLabel.text = "Lap \(lapsTimeInfo.lapArray.count + 1)"
        }
        headerView.headerSeperateView.isHidden = stopwatchState == .Reset
        
        // update button UI
        stopwatchButtonsStackView.lapOrResetButton.isEnabled = stopwatchState != .Reset
        
        stopwatchButtonsStackView.startOrStopButton.setTitle(self.stopwatchState == .Pause || self.stopwatchState == .Reset ? StopwatchState.Start.rawValue : StopwatchState.Pause.rawValue, for: .normal)
        stopwatchButtonsStackView.lapOrResetButton.setTitle(self.stopwatchState == .Pause ? StopwatchState.Reset.rawValue : "分圈", for: .normal)
        stopwatchButtonsStackView.lapOrResetButton.setTitle("分圈", for: .disabled)
        
        if #available(iOS 15, *){
        stopwatchButtonsStackView.startOrStopButton.configurationUpdateHandler = {
            button in
            let alpha = button.isHighlighted ? 0.4 : 0.8
            button.configuration?.background.backgroundColor = self.stopwatchState == .Pause || self.stopwatchState == .Reset ? UIColor.getCustomGreenColor(alpha: alpha) : UIColor.getRedColor(alpha: alpha)
            button.configuration?.attributedTitle?.foregroundColor = self.stopwatchState == .Pause || self.stopwatchState == .Reset ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor()
            }
        } else {
            let alpha = stopwatchButtonsStackView.startOrStopButton.isHighlighted ? 0.4 : 0.8
            stopwatchButtonsStackView.startOrStopButton.layer.backgroundColor = self.stopwatchState == .Pause || self.stopwatchState == .Reset ? UIColor.getCustomGreenColor(alpha: alpha).cgColor : UIColor.getRedColor(alpha: alpha).cgColor
            stopwatchButtonsStackView.startOrStopButton.setTitleColor(stopwatchState == .Pause || self.stopwatchState == .Reset ? UIColor.getDarkGreenColor() : UIColor.getDarkRedColor(), for: .normal)
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
        stopwatchState = stopwatchState == .Reset ? .Start : stopwatchState == .Pause ? .Resume : .Pause
        if stopwatchState == .Start || stopwatchState == .Resume {
            lapsTimeInfo.timeFromStartForFinal = Date()
            lapsTimeInfo.timeFromStartForLap = Date()
            timerForFinal = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForTotal), userInfo: nil, repeats: true)
            timerForLap = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForLap), userInfo: nil, repeats: true)
        } else {
            lapsTimeInfo.timeForFinal = lapsTimeInfo.timeForFinal + Date().timeIntervalSince(lapsTimeInfo.timeFromStartForFinal)
            lapsTimeInfo.timeForLap = lapsTimeInfo.timeForLap + Date().timeIntervalSince(lapsTimeInfo.timeFromStartForLap)
            timerForFinal.invalidate()
            timerForLap.invalidate()
        }
        updateUI()
    }
    
//    @available( iOS 15,*)
    @IBAction func tapLapOrReset(_ sender: UIButton) {
        stopwatchState = stopwatchState == .Pause ? .Reset : stopwatchState
        if stopwatchState == .Start || stopwatchState == .Resume {
            lapsTimeInfo.timeForLap = lapsTimeInfo.timeForLap + Date().timeIntervalSince(lapsTimeInfo.timeFromStartForLap)
            lapsTimeInfo.timeForLap = Double(String(format: "%.4f", lapsTimeInfo.timeForLap)) ?? lapsTimeInfo.timeForLap // 不想要位數過多,想要先四捨五入,再比大小
            
            lapsTimeInfo.lapArray.insert(LapTime(lapNumber: lapsTimeInfo.lapArray.count + 1, lapTimeForString: stringFromTimeInterval(interval: lapsTimeInfo.timeForLap), laptime: lapsTimeInfo.timeForLap), at: 0)
            
            // 更新最大最小值的圈數
            lapsTimeInfo.maxLapTime =  lapsTimeInfo.timeForLap > lapsTimeInfo.maxLapTime ? lapsTimeInfo.timeForLap : lapsTimeInfo.maxLapTime
            lapsTimeInfo.minLapTime = lapsTimeInfo.timeForLap < lapsTimeInfo.minLapTime ? lapsTimeInfo.timeForLap : lapsTimeInfo.minLapTime
            
            // 圈數重新計時
            timerForLap.invalidate()
            lapsTimeInfo.timeForLap = 0
            lapsTimeInfo.timeFromStartForLap = Date()
            timerForLap = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActionForLap), userInfo: nil, repeats: true)

        } else {
            // 重置
            lapsTimeInfo = LapsTimeInfo()
        }
        // 更新 UI
        tableView.reloadData()
        updateUI()
    }
}
extension StopWatchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapsTimeInfo.lapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(StopwatchTableViewCell.self)", for: indexPath) as? StopwatchTableViewCell else { return UITableViewCell() }
        let lapInfo = lapsTimeInfo.lapArray[indexPath.row]
        cell.lap.text = "Lap \(lapInfo.lapNumber)"
        cell.time.text = lapInfo.lapTimeForString
        if lapsTimeInfo.lapArray.count >= 2 {
            // 有超過兩筆以上判斷 最長lap:紅色,最短lap:綠色
            if lapInfo.laptime >= lapsTimeInfo.maxLapTime {
                cell.lap.textColor = UIColor.getDarkRedColor()
                cell.time.textColor = UIColor.getDarkRedColor()
            } else if lapInfo.laptime <= lapsTimeInfo.minLapTime{
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


