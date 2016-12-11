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
    
}

protocol FTSegmentedControlDelegate {
    
    func segmenredControlDidSelect(segmenedControl: FTSegmentedControl, segment: Int) -> Bool;
    
}

@IBDesignable
class FTSegmentedControl: UIView {
    
    var dataSource: FTSegmentedControlDataSource? {
        didSet {
            reloadData()
        }
    }
    
    var delegate: FTSegmentedControlDelegate?

    @IBInspectable
    var borderColor: UIColor = UIColor.blue
    
    @IBInspectable
    var borderWidth: CGFloat = 2.0
    
    @IBInspectable
    var cornerRadius: CGFloat = 5.0
    
    let testLabels:[String] = ["Item 1", "Item 2", "Item 3"]
    var contentView = UIView()
    
    var seletedItem = 0 {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    func configureViews() {
        contentView.clipsToBounds = true
        addSubview(contentView)
        reloadData()
        
    }
    
    func reloadData() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        for segment in 0..<segmentsCount() {
            contentView.addSubview(segmentButton(segment: segment))
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawBorderedBackground()
        drawItems()
    }
    
    func drawBorderedBackground() {
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
        
        contentView.layer.cornerRadius = cornerRadius-borderWidth
        contentView.layer.borderWidth = 0
        contentView.layer.masksToBounds = true
        
        let frame  = layer.bounds
        let width  = frame.width - borderWidth*2
        let height = frame.height - borderWidth*2
        contentView.frame = CGRect(x: borderWidth, y: borderWidth, width: width, height: height)
    }
    
    func drawItems() {
        let itemsCount = testLabels.count
        
        for segment in 0..<itemsCount {
            if let button = findButton(segment: segment) {
                button.frame = segmentRect(segment: segment)
            }
        }
    }
    
    func segmentRect(segment: Int) -> CGRect {
        var itemsCount = dataSource?.segmenredControlCount(segmenedControl: self)
        if (itemsCount == nil) {
            itemsCount = testLabels.count
        }
        
        let cellWidth  = (contentView.layer.bounds.width) / CGFloat(itemsCount!)
        let cellHeight = contentView.layer.bounds.height
            
        return CGRect(x: CGFloat(segment)*cellWidth, y: 0, width: cellWidth, height: cellHeight)
    }
    
    func segmentsCount() -> Int {
        if let itemsCount = dataSource?.segmenredControlCount(segmenedControl: self) {
            return itemsCount
        }
        return testLabels.count
    }
    
    func segmentButton(segment: Int) -> UIButton {
        var segmentButton: UIButton?
        if let button = dataSource?.segmenredControlSegment(segmenedControl: self, segment: segment) {
            segmentButton = button
        } else {
            segmentButton  = UIButton(type: .system)
            segmentButton!.backgroundColor = borderColor.withAlphaComponent(0.3*(CGFloat(segment)+1))
            segmentButton!.tintColor = UIColor.white
            segmentButton?.setTitle("Item \(segment)" , for: .normal)
        }
        
        segmentButton!.frame = segmentRect(segment: segment)
        segmentButton!.tag = segment+1
        
        return segmentButton!
    }
    
    func findButton(segment: Int) -> UIButton? {
        if let button = contentView.viewWithTag(segment+1) as? UIButton {
            return button
        }
        return nil
    }
 
}
