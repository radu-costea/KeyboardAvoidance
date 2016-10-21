//
//  ViewController.swift
//  KeyboardAvoidance
//
//  Created by Radu Costea on 10/19/16.
//  Copyright © 2016 Radu Costea. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController {
    @IBOutlet var contentView: UIView!


    @IBAction func go(_ sender: Any?) {
    }
    
    @IBAction func endEditing(_ sender: UIGestureRecognizer?) {
        self.view.endEditing(true)
        self.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

