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
    
    var count = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
//        testCircleView()
//        testRefresh()
//        test3D()
        testChartView()
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
//        imageView.layer.shadowOpacity = 1
        print("shadowOpacity = \(imageView.layer.shadowOpacity)")
        
        let layer = CALayer()
        layer.frame = CGRectMake(-10, -10, imageView.width + 20, imageView.height + 20)
//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSizeMake(3, 1)
        layer.shadowOpacity = 1
//        layer.borderColor = UIColor.greenColor().CGColor
//        layer.borderWidth = 1
        imageView.layer.insertSublayer(layer, atIndex: 0)
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
    
    func testChartView(){
//        let chartAxesView =  DMChartView.createBarView(frame: CGRectMake(0,50,self.view.width,300))
        let chartAxesView =  DMChartView.createLineView(frame: CGRectMake(0,50,self.view.width,300))
        chartAxesView.backgroundColor = UIColor.lightGrayColor()
        chartAxesView.tag = 200
        self.view.addSubview(chartAxesView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap:")
        chartAxesView.addGestureRecognizer(tapRecognizer)
        
        chartAxesView.labelForXAxes = {(label: UILabel, index : Int)->Void in
            label.text = "第\(index)个"
        }
        chartAxesView.labelForYAxes = {(label: UILabel, index : Int, isMax : Bool)->Void in
            label.textColor = UIColor.yellowColor()
        }
        configChartData(chartAxesView, count: 5, maxValue: 10)
    }
    
    private func configChartData(chartView: DMChartAxesView, count : Int, maxValue : CGFloat){
        chartView.arrayXString.removeAll()
        chartView.arrayData.removeAll()
        for i in 0 ..< count{
            chartView.arrayXString.append(String(i))
            
            let item = DMDataItem()
            item.value = CGFloat(i + 1)
            chartView.arrayData.append(item)
        }
        chartView.valueMax = maxValue
        chartView.valueInterval = maxValue / CGFloat(count)
    }
    
    func onTap(recognizer : UITapGestureRecognizer){
        print("onTap = \(recognizer.view?.tag)")
        if(recognizer.view?.tag == 100){
            UIView.animateWithDuration(10) { () -> Void in
                let view = self.view.viewWithTag(100)!
                let rotationT = CATransform3DRotate(view.layer.transform, DMConsts.PI, 1, 0, 0)
                //        imageView.layer.transform = rotationT
                let rotationPers = DMAnimationUtils.CATransform3DPerspective(rotationT)
                //        imageView.layer.zPosition = 100
                view.layer.transform = rotationPers
            }
        }else if(recognizer.view?.tag == 200){
            let view = self.view.viewWithTag(200) as! DMChartAxesView
            configChartData(view, count: count++, maxValue: 40)
            if(view.arrayXString.count >= 10){
                count = 2
            }
            view.setNeedsDisplay()
        }
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