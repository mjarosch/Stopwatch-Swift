//
//  ViewController.swift
//  Stopwatch
//
//  Created by Mike Jarosch on 2/16/19.
//  Copyright © 2019 Mike Jarosch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var startStop: UIButton!
    @IBOutlet weak var reset: UIButton!

    var _time: Int = 0
    var _timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startStopClicked(_ sender: Any) {
        if let timer = _timer {
            reset.isEnabled = true

            startStop.setTitle("Start", for: .normal)

            timer.invalidate()
            _timer = nil
        } else {
            reset.isEnabled = false

            startStop.setTitle("Stop", for: .normal)

            _timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
                self._time = self._time + 1
                self.updateLabel()
            })
        }
    }

    @IBAction func resetClicked(_ sender: Any) {
        _time = 0
        reset.isEnabled = false
        updateLabel()
    }

    func updateLabel() {
        let hundredth = _time % 100
        let seconds = (_time / 100) % 60
        let minutes = (_time / 6000) % 60
        let hours = _time / 360000
        timerDisplay.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, hundredth);
    }
}

