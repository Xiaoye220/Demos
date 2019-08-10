//
//  CustomLabelViewController.swift
//  TextKitDemo
//
//  Created by YZF on 2018/7/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class CustomLabelViewController: UIViewController {

    let text = try! String(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "txt")!)

    var label: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label = Label(frame: CGRect(x: 10, y: topHeight + 10, width: screenWidth - 20, height: screenHeight - topHeight - 10))
        view.addSubview(label)
        
        label.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
