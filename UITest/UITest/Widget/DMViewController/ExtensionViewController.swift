//
//  ViewController+.swift
//  UITest
//
//  Created by MiloDu on 15/12/26.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

extension ViewController {
    
    var heightStatusBar : CGFloat{
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    var heightNavBar : CGFloat {
        if(self.navigationController != nil){
            return self.navigationController!.navigationBar.frame.size.height
        }
        return 0
    }
    
    var frameView : CGRect{
        return CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - heightStatusBar - heightNavBar)
    }
    
    var frameFull : CGRect{
        return UIScreen.mainScreen().bounds
    }
    
    func showHudLoading(){
        DMProgressView.showHud(ProgressType.Loading,text: "数据加载中...",isTouchToDismiss: true)
    }
    
    func showHudOK(){
        DMProgressView.showHud(ProgressType.OK,text: "", isTouchToDismiss:  true)
    }
    
    func showHudError(){
        DMProgressView.showHud(ProgressType.Error, text: "", isTouchToDismiss: true)
    }
    
    func showHudCustom(){
        DMProgressView.showHud(ProgressType.Custom, text: "", isTouchToDismiss: true)
    }
    
    func hideHud(){
        DMProgressView.hideHud()
    }
}
