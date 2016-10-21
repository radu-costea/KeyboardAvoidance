//
//  RCKeyboardSubscriber.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/19/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit
import CoreGraphics

struct KeyboardEventOptions: OptionSet {
    var rawValue: Int
    
    static var KeyboardWillChangeFrame = KeyboardEventOptions(rawValue: 1 << 0)
    static var KeyboardDidChangeFrame = KeyboardEventOptions(rawValue: 1 << 1)
    static var KeyboardWillShow = KeyboardEventOptions(rawValue: 1 << 2)
    static var KeyboardDidShow = KeyboardEventOptions(rawValue: 1 << 3)
    static var KeyboardWillHide = KeyboardEventOptions(rawValue: 1 << 4)
    static var KeyboardDidHide = KeyboardEventOptions(rawValue: 1 << 5)
}

extension KeyboardEventOptions: Hashable {
    var hashValue: Int { return rawValue }
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

struct KeyboardEventInfo {    
    var eventType: KeyboardEventOptions
    var initialFrame: CGRect
    var finalFrame: CGRect
    var animationCurve: UIViewAnimationCurve
    var animationDuration: Double
    
    init(info: Dictionary<AnyHashable, Any>?, type: KeyboardEventOptions) {
        eventType = type
        initialFrame = (info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        finalFrame = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        animationDuration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        // TODO: for some reason the curve value is 7 which is invalid. Fix this
        animationCurve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .linear
    }
}

class KeyboardSubscriber {
    var keyboardFrame = CGRect.zero
    private var observers: [NSObjectProtocol] = []
    private var notificationCenter: NotificationCenter
    
    init(notificationCenter center: NotificationCenter = NotificationCenter.default) {
        notificationCenter = center
    }
    
    func subscribeToKeyboardEvents(options: KeyboardEventOptions, onEvent: ((KeyboardEventInfo) -> Void)?) {
        stopReceivingKeyboardEvents()
        let notifications = options.corespondingNotifications()
        observers = notifications.map{ pair in
            return self.notificationCenter.addObserver(forName: pair.notification, object: nil, queue: nil, using: { notif in
                let event = KeyboardEventInfo(info: notif.userInfo, type: pair.option)
                onEvent?(event)
            })
        }
    }
    
    func stopReceivingKeyboardEvents() -> Void {
        for observer in observers {
            notificationCenter.removeObserver(observer)
        }
        observers = []
    }
    
    deinit {
        stopReceivingKeyboardEvents()
    }
}
