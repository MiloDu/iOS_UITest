//
//  ViewController.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DMRefreshDelegate {
    let WIDTH_SCREEN = UIScreen.mainScreen().bounds.size.width
    let HEIGHT_SCREEN = UIScreen.mainScreen().bounds.size.height
    
    var circleView : DMCircleView!
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
//        testCircleView()
        testRefresh()
    }
    
    func testCircleView(){
        circleView = DMCircleView(frame: CGRectMake(40,100,240,240))
        self.view.addSubview(circleView)
    }
    
    func testRefresh(){
        tableView = UITableView(frame: self.view.bounds)
        tableView.addRefreshHeader(frame: CGRectMake(0 , 0, 320, 64))
        tableView.delegateRefresh = self
        tableView.addRefreshFooter(frame : CGRectMake(0,0,320,64))
        self.view.addSubview(tableView)
        print("table = \(tableView.frame)")
    }
    
    @IBAction func onButtonClicked(sender: UIButton) {
        print("onbutton clicked")
        if(sender.tag == 1){
            showHudLoading()
        }else if(sender.tag == 2){
            showHudOK()
        }else if(sender.tag == 3){
//            showHudError()
            showHudCustom()
        }
    }
    
    //#prama RefreshDelegate
    func onRefresh(){
        print("onRefresh")
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "refreshEnd", userInfo: nil, repeats: false)
    }
    
    func onLoad(){
        
    }
    
    func refreshEnd(){
        self.tableView.endRefresh()
    }
}