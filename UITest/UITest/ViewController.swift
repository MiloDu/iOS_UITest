//
//  ViewController.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, DMRefreshDelegate {
    let WIDTH_SCREEN = UIScreen.mainScreen().bounds.size.width
    let HEIGHT_SCREEN = UIScreen.mainScreen().bounds.size.height
    
    var circleView : DMCircleView!
    
    let kCell = "Cell"
    var tableView : UITableView!
    var array = Array<String>()
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
        for i in 0 ..< 5 {
            array.append(String(i))
        }
        tableView = UITableView(frame: frameView)
        tableView.registerClass(CellTest.self, forCellReuseIdentifier: kCell)
        tableView.tableFooterView = UIView() //隐藏无效的分割线
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.addRefreshHeader(frame: CGRectMake(0 , 0, 320, 64))
        tableView.addRefreshFooter(frame : CGRectMake(0,0,320,64))
        tableView.delegateRefresh = self
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
    func onRefresh(type : DMRefreshViewType){
        print("onRefresh = \(type)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(type == DMRefreshViewType.Header){
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "refreshHeaderEnd", userInfo: nil, repeats: false)
        }else{
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "refreshFooterEnd", userInfo: nil, repeats: false)
        }
    }
    
    func refreshHeaderEnd(){
        print("refreshHeaderEnd")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.tableView.endRefresh(DMRefreshViewType.Header)
    }
    
    func refreshFooterEnd(){
        print("refreshFooterEnd")
        array.append(String(array.count))
        tableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.tableView.endRefresh(DMRefreshViewType.Footer)
    }
    
    //prama UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(kCell)!
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return array.count
    }
}