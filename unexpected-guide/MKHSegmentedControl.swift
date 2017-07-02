//
//  MKHSegmentedControl.swift
//  Majid Khoshpour
//
//  Created by Majid Khoshpour on 14/01/16.
//  Copyright (c) 2016 Majid Khoshpour. All rights reserved.
//

import UIKit

// MARK: - Appearance

public struct MKHSegmentedControlAppearance {
    public var backgroundColor: UIColor
    public var selectedBackgroundColor: UIColor
    public var textColorUp: UIColor
    public var textColorDown: UIColor
    public var fontUp: UIFont
    public var fontDown: UIFont
    public var selectedTextColor: UIColor
    public var selectedFontUp: UIFont
    public var selectedFontDown: UIFont
    public var bottomLineColor: UIColor
    public var selectorColor: UIColor
    public var bottomLineHeight: CGFloat
    public var selectorHeight: CGFloat
    public var labelTopPadding: CGFloat
    
}


// MARK: - Control Item

typealias MKHSegmentedControlItemAction = (item: MKHSegmentedControlItem) -> Void

class MKHSegmentedControlItem: UIControl {
    
    // MARK: Properties
    
    private var willPress: MKHSegmentedControlItemAction?
    private var didPressed: MKHSegmentedControlItemAction?
    var labelUp: UILabel!
    var labelDown: UILabel!
    
    
    // MARK: Init
    
    init (
        frame: CGRect,
        text: String,
        number: String,
        appearance: MKHSegmentedControlAppearance,
        willPress: MKHSegmentedControlItemAction?,
        didPressed: MKHSegmentedControlItemAction?) {
        super.init(frame: frame)
        self.willPress = willPress
        self.didPressed = didPressed
        labelUp = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        labelDown = UILabel(frame: CGRect(x: 0, y: frame.size.height / 2, width: frame.size.width, height: frame.size.height / 2))
        labelDown.textColor = appearance.textColorDown
        labelUp.textColor = appearance.textColorUp
        labelDown.font = appearance.fontDown
        labelUp.font = appearance.fontUp
        labelDown.textAlignment = .Center
        labelUp.textAlignment = .Center
        labelDown.text = text
        labelUp.text = number
        addSubview(labelDown)
        addSubview(labelUp)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init (coder: aDecoder)
    }
    
    // MARK: Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        willPress?(item: self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        didPressed?(item: self)
    }
}


// MARK: - Control

@objc public protocol MKHSegmentedControlDelegate {
    optional func segmentedControlWillPressItemAtIndex (segmentedControl: MKHSegmentedControl, index: Int)
    optional func segmentedControlDidPressedItemAtIndex (segmentedControl: MKHSegmentedControl, index: Int)
}

public typealias MKHSegmentedControlAction = (segmentedControl: MKHSegmentedControl, index: Int) -> Void

public class MKHSegmentedControl: UIView {
    
    // MARK: Properties
    
    weak var delegate: MKHSegmentedControlDelegate?
    var action: MKHSegmentedControlAction?
    
    public var appearance: MKHSegmentedControlAppearance! {
        didSet {
            self.draw()
        }
    }
    
    var titles: [String]!
    var numbers: [String]!
    var items: [MKHSegmentedControlItem]!
    var selector: UIView!
    
    // MARK: Init
    
    public init (frame: CGRect, titles: [String], numbers: [String],action: MKHSegmentedControlAction? = nil) {
        super.init (frame: frame)
        self.action = action
        self.titles = titles
        self.numbers = numbers
        defaultAppearance()
        //self.layer.shadowOpacity = 0.0
    }
    
    required public init? (coder aDecoder: NSCoder) {
        super.init (coder: aDecoder)
    }
    
    // MARK: Draw
    
    private func reset () {
        for sub in subviews {
            let v = sub
            v.removeFromSuperview()
        }
        items = []
    }
    
    private func draw () {
        reset()
        backgroundColor = appearance.backgroundColor
        let width = frame.size.width / CGFloat(titles.count)
        var currentX: CGFloat = 0
        for title in titles {
            let item = MKHSegmentedControlItem(
                frame: CGRect(
                    x: currentX,
                    y: appearance.labelTopPadding,
                    width: width,
                    height: frame.size.height - appearance.labelTopPadding),
                text: title,
                number: numbers[self.titles.indexOf(title)!],
                appearance: appearance,
                willPress: { segmentedControlItem in
                    let index = self.items.indexOf(segmentedControlItem)!
                    self.delegate?.segmentedControlWillPressItemAtIndex?(self, index: index)
            },
                didPressed: {
                    segmentedControlItem in
                    let index = self.items.indexOf(segmentedControlItem)!
                    self.selectItemAtIndex(index, withAnimation: true)
                    self.action?(segmentedControl: self, index: index)
                    self.delegate?.segmentedControlDidPressedItemAtIndex?(self, index: index)
            })
            addSubview(item)
            items.append(item)
            currentX += width
        }
        //        for item:MKHSegmentedControlItem in items{
        //            for number in numbers{
        //
        //            }
        //        }
        // bottom line
        let bottomLine = CALayer ()
        bottomLine.frame = CGRect(
            x: 0,
            y: frame.size.height - appearance.bottomLineHeight,
            width: frame.size.width,
            height: appearance.bottomLineHeight)
        bottomLine.backgroundColor = appearance.bottomLineColor.CGColor
        layer.addSublayer(bottomLine)
        // selector
        selector = UIView (frame: CGRect (
            x: 0,
            y: frame.size.height - appearance.selectorHeight,
            width: width,
            height: appearance.selectorHeight))
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        
        selectItemAtIndex(0, withAnimation: true)
    }
    
    private func defaultAppearance () {
        appearance = MKHSegmentedControlAppearance(
            backgroundColor: UIColor.clearColor(),
            selectedBackgroundColor: UIColor.clearColor(),
            textColorUp: UIColor(hexString: "4F4F5B"),
            textColorDown: UIColor(hexString: "BCBCBC"),
            fontUp: UIFont(name: "IRANSans(FaNum)", size: 16.0)!,
            fontDown: UIFont(name: "IRANSans(FaNum)", size: 11.0)!,
            selectedTextColor: UIColor.blackColor(),
            selectedFontUp: UIFont(name: "IRANSans(FaNum)", size: 16.0)!,
            selectedFontDown: UIFont(name: "IRANSans(FaNum)", size: 11.0)!,
            bottomLineColor: UIColor.blackColor(),
            selectorColor: UIColor.blackColor(),
            bottomLineHeight: 0.5,
            selectorHeight: 2,
            labelTopPadding: 0)
    }
    
    // MARK: Select
    
    public func selectItemAtIndex (index: Int, withAnimation: Bool) {
        moveSelectorAtIndex(index, withAnimation: withAnimation)
        for item in items {
            if item == items[index] {
                item.labelDown.textColor = appearance.selectedTextColor
                item.labelDown.font = appearance.selectedFontDown
                item.backgroundColor = appearance.selectedBackgroundColor
                item.labelUp.textColor = appearance.selectedTextColor
                item.labelUp.font = appearance.selectedFontUp
                
            } else {
                item.labelDown.textColor = appearance.textColorDown
                item.labelDown.font = appearance.fontDown
                item.backgroundColor = appearance.backgroundColor
                item.labelUp.textColor = appearance.textColorUp
                item.labelUp.font = appearance.fontUp
                
            }
        }
    }
    
    private func moveSelectorAtIndex (index: Int, withAnimation: Bool) {
        let width = frame.size.width / CGFloat(items.count)
        let target = width * CGFloat(index)
        UIView.animateWithDuration(withAnimation ? 0.3 : 0,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {
                                    [unowned self] in
                                    self.selector.frame.origin.x = target
            },
                                   completion: nil)
    }
}
