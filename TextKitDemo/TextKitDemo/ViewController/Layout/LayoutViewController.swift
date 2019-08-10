//
//  LayoutViewController.swift
//  TextKitDemo
//
//  Created by YZF on 2018/7/3.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class LayoutViewController: UIViewController, NSLayoutManagerDelegate {

    
    var textView: UITextView!
    
    let text = try! String(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "txt")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let textStorage = HighlightTextStorage()
        let layoutManager = CustomLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.delegate = self
        
        textView = UITextView(frame: CGRect(x: 10, y: topHeight + 10, width: screenWidth - 20, height: 200), textContainer: textContainer)
        textView.text = text
        textView.showsVerticalScrollIndicator = true
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(textView)
        
        textStorage.string = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 行间距
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex / 10)
    }
    
    /// 段间距
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 10
    }
    
}
