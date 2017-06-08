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
            let iconImageView = UIImageView.newAutoLayout()
            return iconImageView
        }()
        
        var countLabel: UILabel = {
            let countLabel = UILabel.newAutoLayout()
            countLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            countLabel.textAlignment = .left
            countLabel.font = UIFont.systemFont(ofSize: 13, weight: 0.1)
            return countLabel
        }()
        
        fileprivate var centerLayoutGuide: UIView = {
            let centerView = UIView.newAutoLayout()
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
            
            centerLayoutGuide.autoCenterInSuperview()
            centerLayoutGuide.autoSetDimensions(to: suitableValueInPointsOfValueInPixels(CGSize(width: 1, height: 1)))
            
            countLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
            countLabel.autoPinEdge(.left, to: .right, of: centerLayoutGuide, withOffset: suitableValueInPointsOfValueInPixels(7))
            
            iconImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
            iconImageView.autoPinEdge(.right, to: .left, of: centerLayoutGuide, withOffset: suitableValueInPointsOfValueInPixels(7))
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
        let itemHeight = suitableValueInPointsOfValueInPixels(76)
        let indicatorWidth = suitableValueInPointsOfValueInPixels(250)
        let indicatorHeight = suitableValueInPointsOfValueInPixels(2)
        
        for (index, iconImage) in items.enumerated() {
            let itemView = ItemView.newAutoLayout()
            let containerView = UIView.newAutoLayout()
            containerView.alpha = 0.2
            itemView.iconImageView.image = iconImage
            addSubview(containerView)
            containerView.autoPinEdge(toSuperviewEdge: .top)
            containerView.autoPinEdge(.left, to: .left, of: self, withOffset: CGFloat(index) * itemWidth)
            containerView.autoSetDimensions(to: CGSize(width: itemWidth, height: itemHeight))
            containerView.addSubview(itemView)
            itemView.autoPinEdgesToSuperviewEdges()
            containers.append(containerView)
        }
        containers[index].alpha = 1
        indicatorView = UIView.newAutoLayout()
        indicatorView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.5019607843, blue: 0.08235294118, alpha: 1)
        addSubview(indicatorView)
        indicatorView.autoPinEdge(toSuperviewEdge: .bottom)
        indicatorView.autoSetDimensions(to: CGSize(width: indicatorWidth, height: indicatorHeight))
        indicatorAlignAxisConstraint = indicatorView.autoAlignAxis(.vertical, toSameAxisOf: containers.first!)
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
