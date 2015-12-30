//
//  ViewController2.swift
//  UITest
//
//  Created by MiloDu on 15/12/30.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITextFieldDelegate{
    var tap : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test = \(self.view.backgroundColor)")
        self.view.backgroundColor = UIColor.whiteColor()
        addObsever()
        let tf = UITextField(frame: CGRectMake(10,300,320,30))
        tf.tag = 1
        tf.delegate = self
        tf.returnKeyType = UIReturnKeyType.Next
        tf.backgroundColor = UIColor.greenColor()
//        tf.addTarget(self, action: "textFieldDidEnd", forControlEvents: UIControlEvents.EditingDidEnd)
        tf.addTarget(self, action: "textFieldDidEnd", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        self.view.addSubview(tf)
        
        let tf2 = UITextField(frame: CGRectMake(10,400,320,30))
        tf2.tag = 2
        tf2.delegate = self
        tf2.backgroundColor = UIColor.redColor()
        self.view.addSubview(tf2)

        let tf3 = UITextField(frame: CGRectMake(10,600,320,30))
        tf3.tag = 3
        tf3.delegate = self
        tf3.backgroundColor = UIColor.blueColor()
        self.view.addSubview(tf3)
    }
    
    func textFieldDidEnd(){
        print("end")
    }
}

