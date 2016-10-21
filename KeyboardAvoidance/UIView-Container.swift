//
//  UIKeyboardAvoidingView.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/20/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit


/// Container that automatically manages its inner content so that it avoids the keyboard
public protocol KeyboardAvoidingContainer: Container {
    var avoider: KeyboardAvoider { get set }
    func onMove(to window: UIWindow?)
    func setupAvoider() -> KeyboardAvoider
}


// MARK: - Default implementation for KeyboardAvoidingContainer
public extension KeyboardAvoidingContainer {
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

/// Subclass to UIView that automatically adjusts its layout margins to avoid keyboard
public class KeyboardAvoidingView: UIView, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return layoutMargins }
        set {
            layoutMargins = newValue
            layoutIfNeeded()
        }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

/// Subclass to UIScrollView that automatically adjusts its contentInset to avoid keyboard
public class KeyboardAvoidingScrollView: UIScrollView, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

/// Subclass to UITableView that automatically adjusts its contentInset to avoid keyboard
public class KeyboardAvoidingTableView: UITableView, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

/// Subclass to UICollectionView that automatically adjusts its contentInset to avoid keyboard
public class KeyboardAvoidingCollectionView: UICollectionView, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}

/// Subclass to UITextView that automatically adjusts its contentInset to avoid keyboard
public class KeyboardAvoidingTextView: UITextView, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return contentInset }
        set {
            contentInset = newValue
            scrollIndicatorInsets = newValue
        }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}
