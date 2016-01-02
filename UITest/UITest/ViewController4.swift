//
//  ViewController4.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view1 = MyView(frame: frameView)
        view1.backgroundColor = UIColor.whiteColor()
        view1.tag = 1
        self.view = view1
        
        let view2 = MyView(frame: CGRectMake(0, 70, 200,60))
        view2.backgroundColor = UIColor.redColor()
//        view2.userInteractionEnabled = false
        view2.tag = 2
        view1.addSubview(view2)
        
        let view6 = MyView(frame: CGRectMake(100, 0, 200,60))
        view6.backgroundColor = UIColor.yellowColor()
        view6.tag = 21
        view2.addSubview(view6)

        
        let view3 = MyView(frame: CGRectMake(0, 180, 200,200))
        view3.backgroundColor = UIColor.greenColor()
        view3.tag = 3
        view1.addSubview(view3)
        
        let view4 = MyView(frame: CGRectMake(0, 0, 150,150))
        view4.backgroundColor = UIColor.cyanColor()
        view4.tag = 31
        view3.addSubview(view4)
        
        let view5 = MyView(frame: CGRectMake(0, 50, 150,150))
        view5.backgroundColor = UIColor.purpleColor()
        view5.tag = 32
        view3.addSubview(view5)
        
//        view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap:"))
//        view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchedBegan-> viewcontroller")
        super.touchesBegan(touches, withEvent: event)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEnded-> viewcontroller")
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print("touchesCancelled-> viewcontroller")
        super.touchesCancelled(touches, withEvent: event)
    }
    
    func onTap(tapGesture : UIGestureRecognizer){
        print("onTap------>\(tapGesture.view?.tag)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    class MyView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            print("touchedBegan->\(self.tag)")
//            if self.tag != 100{
//        
                super.touchesBegan(touches, withEvent: event)
//            }
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            print("touchesEnded->\(self.tag)")
            super.touchesEnded(touches, withEvent: event)
        }
        override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
            print("touchesCancelled-> \(self.tag)")
            super.touchesCancelled(touches, withEvent: event)
        }

        override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
            print("hitTest ->\(self.tag)")
            if tag == 2 {
                if self.pointInside(point, withEvent: event){
                    return self
                }
            }
            let view = super.hitTest(point, withEvent: event)
            print("hitTest ->\(self.tag) and view tag is \(view?.tag)")
            return view
        }
        
        override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
            print("pointInside ->\(self.tag)")
            let isin = super.pointInside(point, withEvent: event)
            print("pointInside ->\(self.tag) and in is \(isin)")
            return isin
        }
    }
    
    class  MyUIScrollView: UIScrollView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            print("touchedBegan->\(self.tag)")
            //            if self.tag != 100{
            //
            super.touchesBegan(touches, withEvent: event)
            //            }
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            print("touchesEnded->\(self.tag)")
            super.touchesEnded(touches, withEvent: event)
        }
        override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
            print("touchesCancelled-> \(self.tag)")
            super.touchesCancelled(touches, withEvent: event)
        }
        
        override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
            print("hitTest ->\(self.tag)")
            let view = super.hitTest(point, withEvent: event)
            print("hitTest ->\(self.tag) and view tag is \(view?.tag)")
            return view
        }
        
        override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
            print("pointInside ->\(self.tag)")
            let isin = super.pointInside(point, withEvent: event)
            print("pointInside ->\(self.tag) and in is \(isin)")
            return isin
        }
    }
}
