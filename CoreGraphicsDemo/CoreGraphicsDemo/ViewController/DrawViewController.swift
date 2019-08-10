//
//  DrawViewController.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    var drawView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        drawView.center = self.view.center
        self.view.addSubview(drawView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
