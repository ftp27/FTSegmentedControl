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
    func segmenredControlSelectedBackground(segmenedControl: FTSegmentedControl, segment: Int) -> UIColor;
    
}

protocol FTSegmentedControlDelegate {
    
    func segmenredControlDidSelect(segmenedControl: FTSegmentedControl, segment: Int) -> Bool;
    
}

@IBDesignable
class FTSegmentedControl: UIView {
    
    var dataSource: FTSegmentedControlDataSource?
    var delegate: FTSegmentedControlDelegate?

    @IBInspectable
    var borderColor: UIColor = UIColor.blue
    
    @IBInspectable
    var borderWidth: CGFloat = 2.0
    
    @IBInspectable
    var cornerRadius: CGFloat = 5.0
    
    let testLabels:[String] = ["Item 1", "Item 2", "Item 3"]
    var selectionLayer = CALayer()
    var seletedItem = 0 {
        didSet {
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawBorderedBackground()
        drawSelectionLayer()
        drawItems()
    }
    
    func drawBorderedBackground() {
        let borderLayer = CALayer()
        borderLayer.frame = self.layer.bounds
        borderLayer.borderColor = borderColor.cgColor
        borderLayer.cornerRadius = cornerRadius
        borderLayer.borderWidth = borderWidth
        borderLayer.masksToBounds = true;
        borderLayer.name = "borderLayer"
        
        for segment in 0..<segmentsCount() {
            let bgButtonLayer = CALayer()
            let rect:CGRect = segmentRect(segment: segment, border: borderWidth)
            
            bgButtonLayer.frame = rect
            maskSegment(layer: bgButtonLayer, segment: segment)
            bgButtonLayer.backgroundColor = UIColor.blue.withAlphaComponent(0.2*(CGFloat(segment)+1)).cgColor
            borderLayer.addSublayer(bgButtonLayer)
        }
        
        layer.addSublayer(borderLayer)
    }
    
    func drawSelectionLayer() {
        let selectionLayer = CALayer()
        selectionLayer.frame = self.layer.bounds
        selectionLayer.cornerRadius = cornerRadius
        selectionLayer.borderWidth = 0.0
        selectionLayer.masksToBounds = true;
        selectionLayer.name = "selectionLayer"
        
        self.selectionLayer.frame = segmentRect(segment: seletedItem)
        self.selectionLayer.backgroundColor = selectedColor(segment: seletedItem).cgColor
        selectionLayer.addSublayer(self.selectionLayer)
    }
    
    func drawItems() {
        let itemsCount = testLabels.count
        
        for segment in 0..<itemsCount {
            let button  = segmentButton(segment: segment)
            button.setTitle(testLabels[segment], for: .normal)
            maskSegment(layer: button.layer, segment: segment)
            
            self.addSubview(button)
        }
    }
    
    func maskSegment(layer: CALayer, segment: Int) {
        // TODO: Combinate masks
        let cornerRadius = self.cornerRadius-borderWidth
        if segment == 0 {
            let startMaskLayer = CAShapeLayer()
            startMaskLayer.path = UIBezierPath(roundedRect:layer.bounds,
                                               byRoundingCorners:[.topLeft, .bottomLeft],
                                               cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = startMaskLayer
        } else if segment == segmentsCount() - 1 {
            let endMaskLayer = CAShapeLayer()
            endMaskLayer.path = UIBezierPath(roundedRect:layer.bounds,
                                             byRoundingCorners:[.topRight, .bottomRight],
                                             cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = endMaskLayer
        }
    }
    
    func segmentRect(segment: Int) -> CGRect {
        return segmentRect(segment: segment, border: 0)
    }
    
    func segmentRect(segment: Int, border: CGFloat) -> CGRect {
        var itemsCount = dataSource?.segmenredControlCount(segmenedControl: self)
        if (itemsCount == nil) {
            itemsCount = testLabels.count
        }
        
        let cellWidth  = (layer.bounds.width - border*2) / CGFloat(itemsCount!)
        let cellHeight = layer.bounds.height - border*2
            
        return CGRect(x: CGFloat(segment)*cellWidth + border, y: border, width: cellWidth, height: cellHeight)
    }
    
    func segmentsCount() -> Int {
        if let itemsCount = dataSource?.segmenredControlCount(segmenedControl: self) {
            return itemsCount
        }
        return testLabels.count
    }
    
    func segmentButton(segment: Int) -> UIButton {
        if let segmentButton = dataSource?.segmenredControlSegment(segmenedControl: self, segment: segment) {
            return segmentButton
        }
        
        let button  = UIButton(type: .system)
        button.frame = segmentRect(segment: segment)
        button.tintColor = UIColor.white
        
        return button
    }
    
    func selectedColor(segment: Int) -> UIColor {
        if let color = dataSource?.segmenredControlSelectedBackground(segmenedControl: self, segment: segment) {
            return color
        }
        return UIColor.red
    }
    
    func segmentBackground() {
        
    }
 
}
