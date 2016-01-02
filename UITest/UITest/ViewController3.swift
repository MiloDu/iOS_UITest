//
//  ViewController3.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

class ViewController3: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let CellResuseIdentifier = "CellIdentifier1"
    private let CellResuseIdentifier2 = "CellIdentifier2"
    private let HeaderResuseIdentifier = "HeaderIdentifier"
    private var tableView : UITableView!
    private var arrayData = Array<Group>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.frameView)
        self.view.addSubview(tableView)
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        tableView.separatorInset = UIEdgeInsetsZero
        //使分割线靠左边
        tableView.layoutMargins = UIEdgeInsetsZero
        
//        tableView.registerClass(TestCell1.self, forCellReuseIdentifier: CellResuseIdentifier)
        tableView.registerNib(UINib.init(nibName: "TestCell2", bundle: nil), forCellReuseIdentifier: CellResuseIdentifier2)
        tableView.registerClass(TestHeader.self, forHeaderFooterViewReuseIdentifier: HeaderResuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let header = UIView(frame: CGRectMake(0,0,tableView.width,120))
    
        let button = UIButton(frame: CGRectMake(0,0,tableView.width,120))
        button.setBackgroundColor(UIColor.purpleColor(), forState: UIControlState.Normal)
        button.setBackgroundColor(UIColor.yellowColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "onHeaderClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(button)
        
        tableView.tableHeaderView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _loadData()
    }
    
    private func _loadData(){
        for i in 0 ..< 10 {
            let group = Group()
            group.name = "第\(i + 1)组"
            for j in 0 ..< i+1 {
                let item = Item()
                item.text = "第\(i + 1)组"
                item.content = "第\(i + 1)组第\(j + 1)个"
                group.array.append(item)
            }
            arrayData.append(group)
        }
        tableView.reloadData()
    }
    
    func onHeaderClicked(sender: UIControl){
//        print("sender = \(sender)")
        print("header clicked = \(sender.state)")
    }
    
    //MARK: -UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrayData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData[section].array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section % 2 == 0{
            //代码中重写，无需register
            var cell = tableView.dequeueReusableCellWithIdentifier(CellResuseIdentifier) as? TestCell1
            if cell == nil{
                cell = TestCell1(style: UITableViewCellStyle.Default, reuseIdentifier: CellResuseIdentifier)
            }
            cell!.label1.text = arrayData[indexPath.section].array[indexPath.row].content
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }else{
            //必须使用register
            let cell = tableView.dequeueReusableCellWithIdentifier(CellResuseIdentifier2, forIndexPath: indexPath) as! TestCell2
            cell.label1.text = arrayData[indexPath.section].array[indexPath.row].content
            return cell
        }
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        return arrayData[section].name
//    }
    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?{
//        print("set footer title = \(section)")
//        return arrayData[section].name + "footer"
//    }
    
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
//        var array = Array<String>()
//        for i in 0 ..< arrayData.count{
//            array.append("\(i + 1)")
//        }
//        return array
//    }
    
    // tell table which section corresponds to section title/index (e.g. "B",1))
//    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
//        print("title = \(title), index = \(index)")
//        return index
//    }
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
//        
//    }
    
    // Data manipulation - reorder / moving support
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
//        
//    }
    
    
    //MARK: -UITableViewDelegate
    // Variable height support
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section % 2 == 0 {
            return 44
        } else {
            return 150
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        print("set footer height = \(section)")
//        return 40
//    }
    
    // Section header & footer information. Views are preferred over title should you decide to provide both
    // custom view for header. will be adjusted to default or specified header height
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderResuseIdentifier)
        view?.textLabel?.text = "\(section)"
        //Header已经register，所有不会为nil
//        if(view == nil){
//            view = UITableViewHeaderFooterView(reuseIdentifier: HeaderResuseIdentifier)
//            //设置frame无效
//            view?.frame = CGRectMake(0, 0, 320, 400)
//            view?.contentView.backgroundColor = UIColor.yellowColor()
//            print("create header = \(section)")
//        }
        return view
    }
    // custom view for footer. will be adjusted to default or specified footer height
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("set footer view = \(section)")
        let Identifier = "footerIdentifier"
        var view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(Identifier) as? TestFooter
        //Footer未register，所以可能为nil
        if(view == nil){
            view = TestFooter(reuseIdentifier: Identifier)
            //设置frame无效
//            view?.frame = CGRectMake(0, 0, 320, 30)
            print("create footer = \(section)")
        }
        view?.label?.text = "Footer\(section)"
        return view
//        let view2 = UIView()
//        view2.backgroundColor = UIColor.cyanColor()
//        return view2
    }
    
    // Selection
    
    // Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
//        print("willSelectRowAtIndexPath = \(indexPath.section)")
//        if indexPath.section % 2 == 0 {
//            return nil
//        }
//        return indexPath
//    }

    // Called after the user changes the selection.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("didSelectRowAtIndexPath = \(indexPath.section), row = \(indexPath.row)")
    }
}
