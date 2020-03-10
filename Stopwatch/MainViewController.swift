//
//  MainViewController.swift
//  Stopwatch
//
//  Created by Mike Jarosch on 3/9/20.
//  Copyright © 2020 Mike Jarosch. All rights reserved.
//

import UIKit

class MainViewController : UIViewController {
    var _time: Int = 0
    var _lapTime: Int = 0
    var _timer: Timer?
    var _laps: Array<Int> = Array()
    
    var _lapButton: RoundButton!
    var _resetButton: RoundButton!
    var _stackView: UIStackView!
    var _startButton: RoundButton!
    var _stopButton: RoundButton!
    var _timeLabel: UILabel!
    var _lapsTable: UITableView!
    var _tableLabel: UILabel!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        _stackView?.axis = stackViewAxisForTraitCollection(traitCollection)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        
        updateLabels()
    }
    
    func buildView() {
        _stackView = UIStackView()
        _stackView.alignment = .fill
        _stackView.axis = stackViewAxisForTraitCollection(traitCollection)
        _stackView.distribution = .fillEqually
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_stackView)

        _stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        _stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        _stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        _stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
       
        _stackView.addArrangedSubview(buildTimerView())
        _stackView.addArrangedSubview(buildLapView())
    }
    
    func buildTimerView() -> UIView {
        let view = UIView()

        _timeLabel = UILabel()
        _timeLabel.adjustsFontSizeToFitWidth = true
        _timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 85, weight: .thin)
        _timeLabel.numberOfLines = 1
        _timeLabel.minimumScaleFactor = 0.5
        _timeLabel.textAlignment = .center
        _timeLabel.textColor = .lightText
        _timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_timeLabel)

        _timeLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        _timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        _timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        _startButton = createButton(in: view, withTitle: "Start", color: colorFor(red: 81, green: 206, blue: 105), normalFillColor: colorFor(red: 32, green: 88, blue: 37), hightlightedFillColor: colorFor(red: 24, green: 52, blue: 31))
        _startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        _stopButton = createButton(in: view, withTitle: "Stop", color: colorFor(red: 254, green: 50, blue: 25), normalFillColor: colorFor(red: 88, green: 38, blue: 31), hightlightedFillColor: colorFor(red: 52, green: 30, blue: 36))
        _stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        _lapButton  = createButton(in: view, withTitle: "Lap", color: .lightText, normalFillColor: .lightGray, hightlightedFillColor: .darkGray)
        _lapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        _resetButton = createButton(in: view, withTitle: "Reset", color: .lightText, normalFillColor: .lightGray, hightlightedFillColor: .darkGray)
        _resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        _stopButton.widthAnchor.constraint(equalTo: _startButton.widthAnchor).isActive = true
        _lapButton.widthAnchor.constraint(equalTo: _startButton.widthAnchor).isActive = true
        _resetButton.widthAnchor.constraint(equalTo: _startButton.widthAnchor).isActive = true

        _lapButton.setFillColor(colorFor(red: 21, green: 21, blue: 21), for: .disabled)

        _lapButton.isHidden = false
        _lapButton.isEnabled = false
        _resetButton.isHidden = true
        _stopButton.isHidden = true

        _startButton.addTarget(self, action: #selector(startButtonClicked(_:)), for: .touchUpInside)
        _stopButton.addTarget(self, action: #selector(stopButtonClicked(_:)), for: .touchUpInside)
        _lapButton.addTarget(self, action: #selector(lapButtonClicked(_:)), for: .touchUpInside)
        _resetButton.addTarget(self, action: #selector(resetButtonClicked(_:)), for: .touchUpInside)

        return view
    }

    @objc func startButtonClicked(_ sender: Any) {
        _resetButton.isHidden = true
        _lapButton.isHidden = false
        _lapButton.isEnabled = true
        _startButton.isHidden = true
        _stopButton.isHidden = false
        
        if (_laps.count == 0)
        {
            _laps.append(0)
            _lapsTable.reloadData()
        }

        _timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
            self._time = self._time + 1
            self._lapTime = self._lapTime + 1
            self._laps[self._laps.count - 1] = self._lapTime
            self.updateLabels()
        })
        RunLoop.current.add(_timer!, forMode: .common)
    }

    @objc func stopButtonClicked(_ sender: Any) {
        _lapButton.isHidden = true
        _resetButton.isHidden = false
        _stopButton.isHidden = true
        _startButton.isHidden = false

        _timer!.invalidate()
        _timer = nil
    }
    
    @objc func resetButtonClicked(_ sender: Any) {
        _resetButton.isHidden = true
        _lapButton.isHidden = false
        _lapButton.isEnabled = false

        _time = 0
        _lapTime = 0
        _laps.removeAll()

        _lapsTable.reloadData()

        updateLabels()
    }

    @objc func lapButtonClicked(_ sender: Any) {
        _laps[_laps.count - 1] = _lapTime
        _laps.append(0)
        _lapTime = 0
        
        _lapsTable.reloadData()
    }
    
    func buildLapView() -> UIView {
        _lapsTable = UITableView()
        _lapsTable.backgroundColor = .black
        _lapsTable.dataSource = self
        _lapsTable.separatorColor = colorFor(red: 64, green: 64, blue: 64)
        return _lapsTable
    }
    
    func colorFor(red: UInt8, green: UInt8, blue: UInt8) -> UIColor {
        return UIColor(red: CGFloat(Double(red) / 255.0), green: CGFloat(Double(green) / 255.0), blue: CGFloat(Double(blue) / 255.0), alpha: 1)
    }
    
    func createButton(in container: UIView, withTitle titleText: String, color titleColor: UIColor, normalFillColor: UIColor, hightlightedFillColor: UIColor) -> RoundButton
    {
        let button = RoundButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont.systemFont(ofSize: 17)
        button.setTitle(titleText, for: .normal)
        button.setTitleColor(titleColor, for: .normal);
        button.setFillColor(normalFillColor, for: .normal)
        button.setFillColor(hightlightedFillColor, for: .highlighted)
        container.addSubview(button)

        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true

        return button
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

    func stackViewAxisForTraitCollection(_ traitCollection: UITraitCollection) -> NSLayoutConstraint.Axis {
        return traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical;
    }
    
    func updateLabels() {
        _timeLabel!.text = formatTime(_time)
        if let cell = _lapsTable!.cellForRow(at: IndexPath(row: 0, section: 0)) {
            cell.detailTextLabel!.text = formatTime(_lapTime)
        }
    }
}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "ContentCell")
            cell!.backgroundColor = .black
            cell!.textLabel!.textColor = .lightText
            cell!.detailTextLabel!.font = UIFont.monospacedDigitSystemFont(ofSize: cell!.detailTextLabel!.font.pointSize, weight: .regular)
            cell!.selectionStyle = .none
        }
        
        cell!.textLabel!.text = "Lap \(_laps.count - indexPath.row)"
        cell!.detailTextLabel!.text = formatTime(_laps[_laps.count - indexPath.row - 1])

        if (indexPath.row == 0)
        {
            _tableLabel = cell!.detailTextLabel
        }

        return cell!
    }
}
