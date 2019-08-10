//
//  ViewController.swift
//  YFCycleScrollView-Swift
//
//  Created by Xiaoye on 4/5/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var reslutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let array = ["0","1","2","3","4","5"]
        let cycleScrollView = YFCycleScrollView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 200), imageNamed: array)
        cycleScrollView.pageControlTintColor = UIColor.black
        cycleScrollView.pageControlCurrentPageTintColor = UIColor.lightGray
        cycleScrollView.timeInterval = 2
        cycleScrollView.tapHandle = { [weak self] index in
            self?.reslutLabel.text = "currentIndex:" + String(index)
        }
        view.addSubview(cycleScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

