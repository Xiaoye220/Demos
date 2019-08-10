//
//  HighlightViewController.swift
//  TextKitDemo
//
//  Created by YZF on 2018/6/29.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class HighlightViewController: UIViewController {

    let textStorage = HighlightTextStorage()
    
    var textView: UITextView!
    
    let text = try! String(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "txt")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        textView = UITextView(frame: CGRect(x: 10, y: topHeight + 10, width: screenWidth - 20, height: 200))
        textView.text = text
        textView.showsVerticalScrollIndicator = true
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        view.addSubview(textView)
        
        textStorage.addLayoutManager(textView.layoutManager)

        textStorage.string = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
