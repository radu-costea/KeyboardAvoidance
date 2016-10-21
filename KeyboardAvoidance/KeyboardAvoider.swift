//
//  KeyboardAvoider.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/20/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit


/// Container that should have its content avoid keyboard
@objc public protocol Container: NSObjectProtocol {
    func convertRect(_ rect: CGRect, fromView: UIView?) -> CGRect
    var bounds: CGRect { get }
    var insets: UIEdgeInsets { get set }
}


/// Keyboard avoider - object that is responsbile for making sure that the insets of a Container avoid keyboard
public class KeyboardAvoider: NSObject {
    
    /// The container managed by this avoider
    public unowned var container: Container
    
    /// The keyboard subscriber used for observing keyboard events
    public var keyboardSubscriber: KeyboardSubscriber
    
    
    /// The last inset adjustment in order to avoid keyboard
    public var overlapHeight: CGFloat = 0.0 {
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
    
    
    /// Creates a new keyboard avoider
    ///
    /// - parameter keyboardSubscriber: The keyboard subscriber to use for monitoring keyboard state
    /// - parameter container:          The container that will be managed by this avoider
    ///
    /// - returns: A newly created keyboard avoider
    public init(keyboardSubscriber: KeyboardSubscriber, container: Container) {
        self.keyboardSubscriber = keyboardSubscriber
        self.container = container
    }
    
    /// Starts monitoring the keyboard and ajust the insets of the container accordingly
    public func startSubscribing() -> Void {
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
    
    
    /// Stops monitoring keyboard events
    public func stopSubscribing() -> Void {
        keyboardSubscriber.stopReceivingKeyboardEvents()
    }
}

extension UIViewAnimationOptions {
    init(_ curve: UIViewAnimationCurve) {
        self.init(rawValue: UInt(curve.rawValue << 16))
    }
}
