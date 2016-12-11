//
//  FTSegmentedControl.swift
//  FTSegmentedControl-Example
//
//  Created by ftp27 on 10/12/2016.
//  Copyright © 2016 Aleksey Cherepanov. All rights reserved.
//

import UIKit

protocol FTSegmentedControlDataSource {
    
    func segmenredControlCount(segmenedControl: FTSegmentedControl) -> Int;
    func segmenredControlSegment(segmenedControl: FTSegmentedControl, segment: Int) -> UIButton;
    func segmenredControlSegmentWidth(segmenedControl: FTSegmentedControl, segment: Int) -> Float?;
    
}

protocol FTSegmentedControlDelegate {
    
    func segmenredControlDidSelect(segmenedControl: FTSegmentedControl, segment: Int) -> Bool;
    
}

@IBDesignable
public class FTSegmentedControl: UIView {
    
    public var dataSource: FTSegmentedControlDataSource? {
        didSet {
            reloadData()
        }
    }
    
    public var delegate: FTSegmentedControlDelegate?

    @IBInspectable
    public var borderColor: UIColor = UIColor.blue
    
    @IBInspectable
    public var borderWidth: CGFloat = 2.0
    
    @IBInspectable
    public var cornerRadius: CGFloat = 5.0
    
    @IBInspectable
    public var selectedColor: UIColor = UIColor.red {
        didSet {
            selectRect.backgroundColor = selectedColor.cgColor
        }
    }
    
    @IBInspectable
    public var selectedSegment: Int? {
        didSet {
            if let segment = selectedSegment {
                for tag in 0..<segmentsCount() {
                    if let bt = findButton(segment: tag) {
                        if (bt.tag == segment+1) {
                            bt.backgroundColor = UIColor.clear
                        } else {
                            if let bgColor = backgroundsCache[bt.tag] {
                                bt.backgroundColor = bgColor
                            }
                        }
                    }
                }
            }
            drawSelection()
        }
    }
    
    private var borderLayer = CALayer()
    private var selectionLayer = CALayer()
    private var selectRect = CALayer()
    private var contentView = UIView()
    private var backgroundsCache: [Int: UIColor] = [:]
    private var widthCache: [Int: Float] = [:]
    
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        contentView.clipsToBounds = true
        layer.addSublayer(borderLayer)
        layer.addSublayer(selectionLayer)
        selectionLayer.addSublayer(selectRect)
        addSubview(contentView)
        reloadData()
        
    }
    
    public func reloadData() {
        backgroundsCache = [:]
        widthCache = [:]
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        for segment in 0..<segmentsCount() {
            if let width = dataSource?.segmenredControlSegmentWidth(segmenedControl: self, segment: segment) {
                widthCache[segment] = width
            }
        }
        
        for segment in 0..<segmentsCount() {
            contentView.addSubview(segmentButton(segment: segment))
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        draw(layer.bounds)
    }
    
    override public func draw(_ rect: CGRect) {
        drawBorderedBackground()
        drawItems()
        drawSelection()
    }
    
    private func drawBorderedBackground() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 0
        layer.masksToBounds = true
        
        borderLayer.borderColor = borderColor.cgColor
        borderLayer.cornerRadius = cornerRadius
        borderLayer.borderWidth = borderWidth
        
        selectionLayer.cornerRadius = cornerRadius
        selectionLayer.borderWidth = 0
        selectionLayer.masksToBounds = true
        selectRect.backgroundColor = selectedColor.cgColor
        selectRect.borderWidth = 0
        
        contentView.layer.cornerRadius = cornerRadius-borderWidth
        contentView.layer.borderWidth = 0
        contentView.layer.masksToBounds = true
        
        let frame  = layer.bounds
        selectionLayer.frame = frame
        borderLayer.frame = frame
        
        let width  = frame.width - borderWidth*2
        let height = frame.height - borderWidth*2
        contentView.frame = CGRect(x: borderWidth, y: borderWidth, width: width, height: height)
    }
    
    private func drawItems() {
        for segment in 0..<segmentsCount() {
            if let button = findButton(segment: segment) {
                button.frame = segmentRect(segment: segment)
            }
        }
    }
    
    private func segmentRect(segment: Int) -> CGRect {
        var recervedWidth:Float = 0
        for (_,width) in widthCache {
            recervedWidth += width
        }
        let flexableWidth = (Float(contentView.layer.bounds.width) - recervedWidth) / Float(segmentsCount() - widthCache.count)
        let cellWidth  = CGFloat(widthCache[segment] ?? flexableWidth)
        let cellHeight = contentView.layer.bounds.height
        
        recervedWidth = 0
        var recervedCount:Int = 0
        for seg in 0..<segment {
            if let width = widthCache[seg] {
                recervedWidth += width
                recervedCount += 1
            }
        }
        
        let x = recervedWidth + Float(segment - recervedCount) * flexableWidth
        
            
        return CGRect(x: CGFloat(x), y: 0, width: cellWidth, height: cellHeight)
    }
    
    private func segmentsCount() -> Int {
        return dataSource?.segmenredControlCount(segmenedControl: self) ?? 3
    }
    
    private func segmentButton(segment: Int) -> UIButton {
        var segmentButton: UIButton?
        if let button = dataSource?.segmenredControlSegment(segmenedControl: self, segment: segment) {
            segmentButton = button
        } else {
            segmentButton  = UIButton(type: .system)
            segmentButton!.backgroundColor = borderColor.withAlphaComponent(0.3*(CGFloat(segment)+1))
            segmentButton!.tintColor = UIColor.white
            segmentButton!.setTitle("Item \(segment)" , for: .normal)
        }
        
        segmentButton!.frame = segmentRect(segment: segment)
        segmentButton!.tag = segment+1
        segmentButton!.addTarget(self, action: #selector(FTSegmentedControl.willSelectSegment(button:)) , for: .touchUpInside)
        backgroundsCache[segmentButton!.tag] = segmentButton?.backgroundColor
        
        return segmentButton!
    }
    
    private func findButton(segment: Int) -> UIButton? {
        if let button = contentView.viewWithTag(segment+1) as? UIButton {
            return button
        }
        return nil
    }
    
    @objc private func willSelectSegment(button: UIButton?) {
        guard let segment = button?.tag else {
            return
        }
        if (delegate?.segmenredControlDidSelect(segmenedControl: self, segment: segment-1) ?? true) {
            selectedSegment = segment - 1
        }
    }
    
    private func drawSelection() {
        guard let segment = selectedSegment else {
            selectRect.backgroundColor = UIColor.clear.cgColor
            return
        }
        selectRect.backgroundColor = selectedColor.cgColor
        
        guard let button = findButton(segment: segment) else {
            return
        }
        let frame = button.frame
        let y = frame.origin.y
        let height = layer.bounds.height
        
        var x = frame.origin.x
        if (segment != 0) {
            x += borderWidth
        }
        
        var width = frame.width
        if (segment == 0 || segment == segmentsCount()-1) {
            width += borderWidth
        }
        
        selectRect.frame = CGRect(x: x , y: y, width: width, height: height)
    }
 
}
