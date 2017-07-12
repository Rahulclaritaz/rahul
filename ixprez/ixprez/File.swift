//
//  File.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/07/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

    private var handle: UInt8 = 0;
    
    extension UIBarButtonItem {
        
        private var badgeLayer: CAShapeLayer? {
            if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject {
                return b as? CAShapeLayer
            } else {
                return nil
            }
        }
        
        func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            
            badgeLayer?.removeFromSuperlayer()
            
            // Initialize Badge
            let badge = CAShapeLayer()
            let radius = CGFloat(7)
            let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
//            badge.drawCircleAtLocation(location, withRadius: radius, andColor: color, filled: filled)
//            
//            badge.addSublayer(location)
//            badge.addSublayer(radius)
            badge.fillColor = color as! CGColor
            badge.frame.contains(CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y)))
            
            view.layer.addSublayer(badge)
            
            // Initialiaze Badge's label
            let label = CATextLayer()
            label.string = "\(number)"
            label.alignmentMode = kCAAlignmentCenter
            label.fontSize = 11
            label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
            label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            badge.addSublayer(label)
            
            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        func updateBadge(number number: Int) {
            if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
                text.string = "\(number)"
            }
        }
        
        func removeBadge() {
            badgeLayer?.removeFromSuperlayer()
        }
        
    }

