//
//  ViewController.swift
//  Stopwatch
//
//  Created by Mike Jarosch on 2/16/19.
//  Copyright © 2019 Mike Jarosch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var resetButton: RoundButton!
    @IBOutlet weak var lapButton: RoundButton!
    @IBOutlet weak var stopButton: RoundButton!
    @IBOutlet weak var lapsView: UITableView!
    
    var _time: Int = 0
    var _lastLapTime: Int = 0
    var _timer: Timer?
    var _laps: Array<Int> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        resetButton.isHidden = true
        lapButton.isHidden = false
        lapButton.isEnabled = true
        startButton.isHidden = true
        stopButton.isHidden = false

        _timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
            self._time = self._time + 1
            self.updateLabel()
        })
    }

    @IBAction func stopButtonClicked(_ sender: Any) {
        lapButton.isHidden = true
        resetButton.isHidden = false
        stopButton.isHidden = true
        startButton.isHidden = false

        _timer!.invalidate()
        _timer = nil
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        resetButton.isHidden = true
        lapButton.isHidden = false
        lapButton.isEnabled = false

        _time = 0
        _lastLapTime = 0
        _laps.removeAll()

        lapsView.reloadData()

        updateLabel()
    }

    @IBAction func lapButtonClicked(_ sender: Any) {
        _laps.append(_time - _lastLapTime)
        _lastLapTime = _time
        
        lapsView.reloadData()
    }

    func updateLabel() {
        timerDisplay.text = formatTime(_time)
    }

    func formatTime(_ time: Int) -> String {
        let hundredth = time % 100
        let seconds = (time / 100) % 60
        let minutes = (time / 6000) % 60
        let hours = time / 360000
        if (hours > 0) {
            return String(format: "%d:%02d:%02d.%02d", hours, minutes, seconds, hundredth);
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, hundredth);
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _laps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)

        cell.textLabel!.text = String(format: "Lap %i", _laps.count - indexPath.row)
        cell.detailTextLabel!.text = formatTime(_laps[_laps.count - indexPath.row - 1])

        return cell
    }

}

