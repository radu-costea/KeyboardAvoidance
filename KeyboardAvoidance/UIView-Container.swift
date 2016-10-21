//
//  UIKeyboardAvoidingView.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/20/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit

protocol KeyboardAvoidingContainer: Container {
    var avoider: KeyboardAvoider { get set }
    func onMove(to window: UIWindow?)
    func setupAvoider() -> KeyboardAvoider
}

extension KeyboardAvoidingContainer {
    func setupAvoider() -> KeyboardAvoider {
        return KeyboardAvoider(keyboardSubscriber: KeyboardSubscriber(), container: self)
    }
    
    func onMove(to window: UIWindow?) {
        if (window != nil) {
            avoider.startSubscribing()
        } else {
            avoider.stopSubscribing()
        }
    }
}

class KeyboardAvoidingView: UIView, KeyboardAvoidingContainer {
    var insets: UIEdgeInsets {
        get { return layoutMargins }
        set {
            layoutMargins = newValue
            layoutIfNeeded()
        }
    }
    lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

class KeyboardAvoidingScrollView: UIScrollView, KeyboardAvoidingContainer {
    var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

class KeyboardAvoidingTableView: UITableView, KeyboardAvoidingContainer {
    var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

class KeyboardAvoidingCollectionView: UICollectionView, KeyboardAvoidingContainer {
    var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

class KeyboardAvoidingTextView: UITextView, KeyboardAvoidingContainer {
    var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}
