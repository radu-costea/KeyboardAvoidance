# KeyboardAvoidanceKit
A framework that provides all the tools you need to implement keyboard avoiding in your app with a minmum effort.

## How it works?

It adjusts the insets of a view so that the content inside it avoids keyboard.

Note that you don't need to add additional constraints or do anything more aside to identify the correct container and set it as one of the given containers subclasses.

## Supported containers:

1. `UIView` - any content that is placed inside this view will be rearanged if placed correctly. It uses layout margins as the insets, so make sure that the subviews relate to this view margin instead of this view edge. 
Also make sure that if you have constrains for vertical align or so you specify them as relative to margin.

2. `UIScrollView` - the content of this UIScrollView will be scrollable entirely without overlaping with the keyboard. It uses content insets to make sure that content avoids keyboard.
3. Subclasses of `UIScrollView` as: `UITableView`, `UICollectionView`, `UITextView`. they work the same as `UIScrollView`. If you need anything else that is not implemented here you can use the current subclasses as models.

## How to use it?

All you need to to is to specify the class of a container as being one of keyboard avoiding containers.

Note: Make sure that you also specify the correct module for the custom class or you might wonder why its not working.

## Components:

1. `KeyboardSubscriber` - is a simple object that registers to keyboard events. It can be used to monitor keyboard state, and also it caches the last frame of the keyboard.
2. `KeyboardAvoider` - An object that manages a container. It uses a keyboard subscriber to monitor the keyboard state and ajusts the container insets in order to make sure it avoids keyboard
3. `KeyboardAvoidingContainer` - It a default implementation for containers that automagically adjust their content in order to avoid keyboard. Use this if you need to implement a custom container.

## How to make a custom container?

Your custom container should look something like this

```swift
/// Subclass that automatically adjusts its contentInset to avoid keyboard
public class <#Your class#>: <#Superclass#>, KeyboardAvoidingContainer {
    public var insets: UIEdgeInsets {
        get { return <#insets#> }
        set { <#insets#> = newValue }
    }
    public lazy var avoider: KeyboardAvoider = self.setupAvoider()
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        onMove(to: newWindow)
    }
}
```
