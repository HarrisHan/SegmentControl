//
//  ViewController.swift
//  SegmentControl
//
//  Created by Harris on 08/06/2017.
//  Copyright © 2017 Harris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var segmentControl: SegmentControl = {
        let images = [UIImage(named: "left"),UIImage(named: "right")]
        let sc = SegmentControl(images as! [UIImage])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentControlValueChange(_:)), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeUserInterface()
    }
    
    private func initializeUserInterface() {
        view.addSubview(segmentControl)

        let margins = view.layoutMarginsGuide
        segmentControl.topAnchor.constraint(equalTo: margins.topAnchor, constant: 66).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 0).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc fileprivate func segmentControlValueChange(_ segmentControl: SegmentControl) {
        print(segmentControl.index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

