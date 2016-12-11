//
//  ViewController.swift
//  FTSegmentedControl-Example
//
//  Created by ftp27 on 10/12/2016.
//  Copyright © 2016 Aleksey Cherepanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FTSegmentedControlDelegate, FTSegmentedControlDataSource {

    @IBOutlet weak var segmentedControl: FTSegmentedControl!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.delegate = self
        segmentedControl.dataSource = self
        segmentedControl.selectSegment(segment: 0)
    }

    func segmenredControlCount(segmenedControl: FTSegmentedControl) -> Int {
        return 4
    }
    
    func segmenredControlSegment(segmenedControl: FTSegmentedControl, segment: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Tab \(segment)", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.green.withAlphaComponent(0.25*(CGFloat(segment)+1))
        return button
    }
    
    func segmenredControlDidSelect(segmenedControl: FTSegmentedControl, segment: Int) -> Bool {
        label.text = "Item \(segment)"
        return (segment != 3)
    }

}

