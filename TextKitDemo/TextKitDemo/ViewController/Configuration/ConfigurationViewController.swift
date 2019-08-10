//
//  ConfigurationViewController.swift
//  TextKitDemo
//
//  Created by YZF on 2018/6/29.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

    var textStorage: NSTextStorage!
    var layoutManager: NSLayoutManager!
    var textContainer: NSTextContainer!
    
    var textView_1: UITextView!
    var textView_2: UITextView!
    var textView_3: UITextView!
    
    let text = try! String(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "txt")!)
    
    var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        barButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEdit))
        navigationItem.rightBarButtonItem = barButtonItem
        
        textView_1 = UITextView(frame: CGRect(x: 10, y: topHeight + 10, width: screenWidth - 20, height: 200))
        textView_1.text = text
        textView_1.showsVerticalScrollIndicator = true
        textView_1.layer.borderColor = UIColor.black.cgColor
        textView_1.layer.borderWidth = 1
        view.addSubview(textView_1)

        textStorage = textView_1.textStorage
        layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        // 默认初始化 size 为 1000万*1000万。若初始化指定 size，那么 textView 则以 origin 开始指定 size 的部分才能显示
        // layoutManager 包含 textContainer_2 以及 textContainer_3，则 textStorage 内容会在这两个 Container 上布局
        // textContainer_2 逐行显示完后，在 textContainer_3 显示
        // 同时因为公用同个 textStorage， 对任意 textView 进行修改，会造成所有的 textView 内容或布局修改
        let textContainer_2 = NSTextContainer()
        layoutManager.addTextContainer(textContainer_2)
        let textContainer_3 = NSTextContainer()
        layoutManager.addTextContainer(textContainer_3)
        
        
        textView_2 = UITextView(frame: CGRect(x: 10, y: topHeight + 220, width: screenWidth/2 - 15, height: 200), textContainer: textContainer_2)
        textView_2.isScrollEnabled = false
        textView_2.layer.borderColor = UIColor.black.cgColor
        textView_2.layer.borderWidth = 1
        textView_2.textContainer.size = textView_2.frame.size
        view.addSubview(textView_2)

        textView_3 = UITextView(frame: CGRect(x: screenWidth/2 + 5, y: topHeight + 220, width: screenWidth/2 - 15, height: 200), textContainer: textContainer_3)
        textView_3.showsVerticalScrollIndicator = true
        textView_3.layer.borderColor = UIColor.black.cgColor
        textView_3.layer.borderWidth = 1
        textView_3.textContainer.size = textView_3.frame.size
        view.addSubview(textView_3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func endEdit() {
        self.view.endEditing(true)
    }
    
}
