//
//  RoundButton.swift
//  Stopwatch
//
//  Created by Mike Jarosch on 3/10/19.
//  Copyright © 2019 Mike Jarosch. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    var _fillValues: Dictionary<UInt, UIColor?> = Dictionary()
    var _outerCircleLayer: CALayer = CALayer()
    var _innerCircleLayer: CALayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    var currentFillColor: UIColor {
        get {
            return fillColor(for: state)!
        }
    }

    private var _defaultFillColor: UIColor? {
        get {
            return UIColor.clear;
        }
    }

    @IBInspectable
    var fillColorForNormal: UIColor? {
        get {
            return fillColor(for: .normal)
        }
        set {
            setFillColor(newValue, for: .normal)
        }
    }

    @IBInspectable
    var fillColorForHighlighted: UIColor? {
        get {
            return fillColor(for: .highlighted)
        }
        set {
            setFillColor(newValue, for: .highlighted)
        }
    }

    @IBInspectable
    var fillColorForSelected: UIColor? {
        get {
            return fillColor(for: .selected)
        }
        set {
            setFillColor(newValue, for: .selected)
        }
    }

    @IBInspectable
    var fillColorForDisabled: UIColor? {
        get {
            return fillColor(for: .disabled)
        }
        set {
            setFillColor(newValue, for: .disabled)
        }
    }

    override var isSelected: Bool {
        set {
            super.isSelected = newValue

            updateCircleColorForState()
        }
        get {
            return super.isSelected
        }
    }

    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue

            updateCircleColorForState()
        }
        get {
            return super.isHighlighted
        }
    }

    override var isEnabled: Bool {
        set {
            super.isEnabled = newValue

            updateCircleColorForState()
        }
        get {
            return super.isEnabled
        }
    }

    func commonInit() {
        _outerCircleLayer.borderWidth = 2.0
        layer.insertSublayer(_outerCircleLayer, at: 0)

        _innerCircleLayer.masksToBounds = true
        layer.insertSublayer(_innerCircleLayer, at: 0)
        
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        updateCircleColorForState()
    }

    override func layoutSubviews() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let innerFrame = outerFrame.insetBy(dx: 3.0, dy: 3.0)

        _outerCircleLayer.frame = outerFrame
        _outerCircleLayer.cornerRadius = outerFrame.size.width / 2.0
        _outerCircleLayer.position = center

        _innerCircleLayer.frame = innerFrame
        _innerCircleLayer.cornerRadius = innerFrame.size.width / 2.0
        _innerCircleLayer.position = center

        super.layoutSubviews()
    }

    func updateCircleColorForState() {
        let fillColor = currentFillColor.cgColor
        _outerCircleLayer.borderColor = fillColor
        _innerCircleLayer.backgroundColor = fillColor
    }

    func fillColor(for state: UIControl.State) -> UIColor? {
        return _fillValues[state.rawValue] ?? _fillValues[UIControl.State.normal.rawValue] ?? _defaultFillColor
    }

    func setFillColor(_ color: UIColor?, for state: UIControl.State) {
        if (color != nil) {
            _fillValues[state.rawValue] = color
        } else {
            _fillValues.removeValue(forKey: state.rawValue)
        }

        updateCircleColorForState()
    }
}
