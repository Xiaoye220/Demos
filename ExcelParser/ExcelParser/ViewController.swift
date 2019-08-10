//
//  ViewController.swift
//  ExcelParser
//
//  Created by YZF on 7/9/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workbook = XlsxReader.shared.open(Bundle.main.path(forResource: "测试", ofType: "xlsx")!)
        dump(workbook)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

