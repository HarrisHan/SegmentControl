//
//  SegmentControl.swift
//  SegmentControl
//
//  Created by Harris on 08/06/2017.
//  Copyright © 2017 Harris. All rights reserved.
//

import UIKit

class SegmentControl: UIControl {
    
    fileprivate class ItemView: UIView {
        
        var iconImageView: UIImageView = {
            let iconImageView = UIImageView()
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            return iconImageView
        }()
        
        var countLabel: UILabel = {
            let countLabel = UILabel()
            countLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            countLabel.text = "13"
            countLabel.textAlignment = .left
            countLabel.font = UIFont.systemFont(ofSize: 13, weight: 0.1)
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            return countLabel
        }()
        
        fileprivate var centerLayoutGuide: UIView = {
            let centerView = UIView()
            centerView.translatesAutoresizingMaskIntoConstraints = false
            return centerView
        }()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUserInterface()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUserInterface()
        }
        
        func setupUserInterface() {
            
            addSubview(countLabel)
            addSubview(iconImageView)
            addSubview(centerLayoutGuide)
            
            let margins = layoutMarginsGuide
            centerLayoutGuide.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
            centerLayoutGuide.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
            centerLayoutGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
            centerLayoutGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            countLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
            countLabel.leftAnchor.constraint(equalTo: centerLayoutGuide.layoutMarginsGuide.rightAnchor, constant: 3.5).isActive = true
            
            iconImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
            iconImageView.rightAnchor.constraint(equalTo: centerLayoutGuide.layoutMarginsGuide.leftAnchor, constant: 3.5).isActive = true
        }
        
    }
    
    var index: Int = 0
    
    fileprivate var indicatorView: UIView!
    fileprivate var items: [UIImage] = []
    fileprivate var containers: [UIView] = []
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate var indicatorAlignAxisConstraint: NSLayoutConstraint!
    
    init(_ item:[UIImage]) {
        super.init(frame: CGRect.zero)
        items = item
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUserInterface()
    }
    
    fileprivate func setupUserInterface() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.05)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGesture)
        
        let itemWidth = screenWidth / CGFloat(items.count)
        let itemHeight: CGFloat = 38.0
        let indicatorWidth: CGFloat = 125.0
        let indicatorHeight: CGFloat = 1.0
       
        let margins = layoutMarginsGuide

        for (index, iconImage) in items.enumerated() {
            let itemView = ItemView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.alpha = 0.2
            itemView.iconImageView.image = iconImage
            addSubview(containerView)
            containerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
            containerView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: CGFloat(index) * itemWidth).isActive = true
            containerView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
            containerView.addSubview(itemView)
         
            let containerMargins = containerView.layoutMarginsGuide
            itemView.topAnchor.constraint(equalTo: containerMargins.topAnchor).isActive = true
            itemView.leftAnchor.constraint(equalTo: containerMargins.leftAnchor).isActive = true
            itemView.bottomAnchor.constraint(equalTo: containerMargins.bottomAnchor).isActive = true
            itemView.rightAnchor.constraint(equalTo: containerMargins.rightAnchor).isActive = true
            containers.append(containerView)
        }
        containers[index].alpha = 1
        indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.5019607843, blue: 0.08235294118, alpha: 1)
        addSubview(indicatorView)
        indicatorView.bottomAnchor.constraint(equalTo:margins.bottomAnchor).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: indicatorHeight).isActive = true
        indicatorAlignAxisConstraint = indicatorView.centerYAnchor.constraint(equalTo: (containers.first?.layoutMarginsGuide.centerYAnchor)!)
        indicatorAlignAxisConstraint.isActive = true
    }
    
    
    // MARK: Helper
    fileprivate func nearestIndex(toPoint point: CGPoint) -> Int {
        let distances = containers.map { abs(point.x - $0.center.x) }
        return Int(distances.index(of: distances.min()!)!)
    }
    
    // MARK: Actions
    @objc fileprivate func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        moveIndicator(nearestIndex(toPoint: location))
    }
    
    // MARK: Animations
    fileprivate func moveIndicator(_ index: Int) {
        self.index = index
        containers[index].alpha = 1
        containers.filter{$0 != containers[index] }.forEach{$0.alpha = 0.2}
        indicatorAlignAxisConstraint.constant = screenWidth / CGFloat(items.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        self.sendActions(for: .valueChanged)
    }

}
