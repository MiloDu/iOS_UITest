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
//        testRefresh()
        test3D()
    }
    
    func testCircleView(){
        circleView = DMCircleView(frame: CGRectMake(40,100,240,240))
        self.view.addSubview(circleView)
    }
    
    func test3D(){
        let image = UIImage(named: "image")!
        let imageView = UIImageView(frame: CGRectMake(0, 200, image.size.width + 100, image.size.height))
        imageView.layer.backgroundColor = UIColor.greenColor().CGColor
        imageView.backgroundColor = UIColor.redColor()
        imageView.contentMode = UIViewContentMode.Center
        imageView.image = image
        imageView.layer.anchorPoint = CGPointMake(0.5, 0)
        var frame = imageView.frame
        frame.origin.y -= frame.size.height * 0.5
        imageView.frame = frame

        imageView.tag = 100
        imageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap:")
        imageView.addGestureRecognizer(tapRecognizer)
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap"))
        self.view.addSubview(imageView)
    }
    
    func onTap(recognizer : UITapGestureRecognizer){
        print("onTap")
        UIView.animateWithDuration(10) { () -> Void in
            let view = self.view.viewWithTag(100)!
            let rotationT = CATransform3DRotate(view.layer.transform, DMConsts.PI, 1, 0, 0)
            //        imageView.layer.transform = rotationT
            let rotationPers = DMLayerUtils.CATransform3DPerspective(rotationT)
            //        imageView.layer.zPosition = 100
            view.layer.transform = rotationPers
        }
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
    
    @IBAction func onRefreshClicked(sender: UIBarButtonItem) {
        tableView.beginRefresh()
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