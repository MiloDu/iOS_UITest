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
    
    var heightTabBar : CGFloat {
        if(self.tabBarController != nil){
            return self.tabBarController!.tabBar.frame.size.height
        }
        return 0
    }

    var frameView : CGRect{
        var y : CGFloat = 0
        var height : CGFloat = self.view.frame.size.height
        if(self.navigationController == nil && self.tabBarController == nil){
            y = heightStatusBar
            height -= heightStatusBar
        }else if(self.edgesForExtendedLayout == UIRectEdge.None){
            height -= (heightStatusBar + heightNavBar + heightTabBar)
            if(self.navigationController == nil){
                y = heightStatusBar
            }
        }
        return CGRectMake(0, y, self.view.frame.width, height)
    }
    
    var frameFull : CGRect{
        return UIScreen.mainScreen().bounds
    }
    
    func showHudLoading(){
        DMNoticeView.showHud(DMNoticeType.Loading,text: "数据加载中...",isTouchToDismiss: true)
    }
    
    func showHudOK(){
        DMNoticeView.showHud(DMNoticeType.OK,text: "", isTouchToDismiss:  true)
    }
    
    func showHudError(){
        DMNoticeView.showHud(DMNoticeType.Error, text: "", isTouchToDismiss: true)
    }
    
    func showHudCustom(){
        DMNoticeView.showHud(DMNoticeType.Custom, text: "", isTouchToDismiss: true)
    }
    
    func hideHud(){
        DMNoticeView.hideHud()
    }
}
