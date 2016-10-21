//
//  RCKeyboardSubscriber.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/19/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit
import CoreGraphics

public struct KeyboardEventOptions: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var KeyboardWillChangeFrame = KeyboardEventOptions(rawValue: 1 << 0)
    public static var KeyboardDidChangeFrame = KeyboardEventOptions(rawValue: 1 << 1)
    public static var KeyboardWillShow = KeyboardEventOptions(rawValue: 1 << 2)
    public static var KeyboardDidShow = KeyboardEventOptions(rawValue: 1 << 3)
    public static var KeyboardWillHide = KeyboardEventOptions(rawValue: 1 << 4)
    public static var KeyboardDidHide = KeyboardEventOptions(rawValue: 1 << 5)
}

extension KeyboardEventOptions: Hashable {
    public var hashValue: Int { return rawValue }
}

extension KeyboardEventOptions {
    func corespondingNotifications() -> [(option: KeyboardEventOptions, notification: Notification.Name)] {
        let pairing: [KeyboardEventOptions : Notification.Name] = [
            .KeyboardWillChangeFrame: .UIKeyboardWillChangeFrame,
            .KeyboardDidChangeFrame: .UIKeyboardDidChangeFrame,
            .KeyboardWillShow: .UIKeyboardWillShow,
            .KeyboardDidShow: .UIKeyboardDidShow,
            .KeyboardWillHide: .UIKeyboardWillHide,
            .KeyboardDidHide: .UIKeyboardDidHide,
        ]
        let selected = pairing.filter{ self.contains($0.key) }
        return selected.map{ (option: $0.key, notification: $0.value )}
    }
}

public class KeyboardEventInfo: NSObject {
    public var eventType: KeyboardEventOptions
    public var initialFrame: CGRect
    public var finalFrame: CGRect
    public var animationCurve: UIViewAnimationCurve
    public var animationDuration: Double
    
    public init(info: Dictionary<AnyHashable, Any>?, type: KeyboardEventOptions) {
        eventType = type
        initialFrame = (info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        finalFrame = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        animationDuration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        // TODO: for some reason the curve value is 7 which is invalid. Fix this
        animationCurve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .linear
    }
}

public class KeyboardSubscriber: NSObject {
    /// The current frame of the keyboard in window coordinate space system
    public var keyboardFrame = CGRect.zero
    
    private var notificationCenter: NotificationCenter
    private var observers: [NSObjectProtocol] = []
    
    /// Creates a keyboard subscriber. This object is responsible for listening to keyboard events 
    ///
    /// - parameter center: Notification center used to listen keyboard events
    ///
    /// - returns: A newly created KeyboardSubscriber
    public init(notificationCenter center: NotificationCenter = NotificationCenter.default) {
        notificationCenter = center
    }
    
    
    /// Registers to specified keyboard events and calls the onEvent callback when
    ///
    /// - parameter options: The events to register for
    /// - parameter onEvent: The callback to be called when one of the specified events occur
    public func subscribeToKeyboardEvents(options: KeyboardEventOptions, onEvent: ((KeyboardEventInfo) -> Void)?) {
        // Prevent from registering multiple times by unregister previous observers
        stopReceivingKeyboardEvents()
        
        // Map selected options to corresponding Notification names
        let notifications = options.corespondingNotifications()
        
        // Register observers for each notification
        observers = notifications.map{ pair in
            return self.notificationCenter.addObserver(forName: pair.notification, object: nil, queue: nil, using: { notif in
                let event = KeyboardEventInfo(info: notif.userInfo, type: pair.option)
                onEvent?(event)
            })
        }
    }
    
    
    /// Stops listening to keyboard registered events
    public func stopReceivingKeyboardEvents() -> Void {
        observers.forEach { [unowned self] in
            self.notificationCenter.removeObserver($0)
        }
        observers = []
    }
    
    deinit {
        stopReceivingKeyboardEvents()
    }
}
