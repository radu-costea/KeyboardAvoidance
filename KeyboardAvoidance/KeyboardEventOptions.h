//
//  KeyboardEventOptions.h
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/21/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, KeyboardEventOptions) {
    KeyboardWillChangeFrame = (1 << 0),
    KeyboardDidChangeFrame = (1 << 1),
    KeyboardWillShow = (1 << 2),
    KeyboardDidShow = (1 << 3),
    KeyboardWillHide = (1 << 4),
    KeyboardDidHide = (1 << 5),
};
