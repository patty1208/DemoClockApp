//
//  EditTimerSoundTableViewController.swift
//  EditTimerSoundTableViewController
//
//  Created by 林佩柔 on 2021/10/12.
//

import UIKit
import AVFoundation

class EditTimerSoundTableViewController: UITableViewController {
    let ringtonesList = Sound.data
    var ringtone: Sound
    var selectIndex: Int
    var player: AVPlayer?
    
    // MARK: - init
    init?(coder: NSCoder, ringtone: Sound){
        self.ringtone = ringtone
        self.selectIndex = ringtonesList.firstIndex(of: ringtone) ?? 0
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    // MARK: - button action
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringtonesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SoundTableViewCell.self)", for: indexPath) as? SoundTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        cell.soundLabel.text = ringtonesList[row].soundName
        cell.accessoryType = row == selectIndex ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        ringtone = ringtonesList[selectIndex]
        
        if let url = Bundle.main.url(forResource: Sound.data[selectIndex].soundFile, withExtension: Sound.data[selectIndex].sounfFileExtension){
            player = AVPlayer(url: url)
            player?.play()
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
