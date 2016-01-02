//
//  TestCell2.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

class TestCell2: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onButtonClicked(sender: AnyObject) {
        print("onButtonClicked")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _config()
    }

    private func _config(){
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
