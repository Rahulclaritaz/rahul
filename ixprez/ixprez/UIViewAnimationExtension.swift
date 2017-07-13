//
//  UIViewAnimationExtension.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 13/07/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

extension UIView {
    
    
    func zoomInWithEasing( duration: TimeInterval = 3.2, easingOffset: CGFloat = 1.0) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    func zoomOutWithEasing(duration: TimeInterval = 3.2, easingOffset: CGFloat = 0.1) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
}
