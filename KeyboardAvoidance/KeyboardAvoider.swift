//
//  KeyboardAvoider.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/20/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit

protocol Container: class {
    func convertRect(_ rect: CGRect, fromView: UIView?) -> CGRect
    var bounds: CGRect { get }
    var insets: UIEdgeInsets { get set }
}

class KeyboardAvoider {
    unowned var container: Container
    var keyboardSubscriber: KeyboardSubscriber
    
    var overlapHeight: CGFloat = 0.0 {
        willSet {
            var oldInsets = container.insets
            oldInsets.bottom -= overlapHeight
            container.insets = oldInsets
        }
        didSet {
            var oldInsets = container.insets
            oldInsets.bottom += overlapHeight
            container.insets = oldInsets
        }
    }
    
    init(keyboardSubscriber: KeyboardSubscriber, container: Container) {
        self.keyboardSubscriber = keyboardSubscriber
        self.container = container
    }
    
    func startSubscribing() -> Void {
        keyboardSubscriber.subscribeToKeyboardEvents(options: .KeyboardWillChangeFrame) { [unowned self] (info) in
            let rect = self.container.convertRect(info.finalFrame, fromView: nil)
            let intersection = self.container.bounds.intersection(rect)
            let option = UIViewAnimationOptions(info.animationCurve)
            
            UIView.animate(withDuration: info.animationDuration,
                           delay: 0.0,
                           options: option,
                           animations: {
                            self.overlapHeight = intersection.size.height
            }, completion: nil)
        }
    }
    
    func stopSubscribing() -> Void {
        keyboardSubscriber.stopReceivingKeyboardEvents()
    }
}

extension UIViewAnimationOptions {
    init(_ curve: UIViewAnimationCurve) {
        self.init(rawValue: UInt(curve.rawValue << 16))
    }
}
