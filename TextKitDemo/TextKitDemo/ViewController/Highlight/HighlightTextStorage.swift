//
//  HighlightTextStorage.swift
//  TextKitDemo
//
//  Created by YZF on 2018/6/29.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class HighlightTextStorage: NSTextStorage {

    var imp: NSMutableAttributedString
    
//    let pattern = "^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}$"
    var pattern = "萧炎"
    var expression: NSRegularExpression {
        let expression = try! NSRegularExpression(pattern: pattern, options: [])
        return expression
    }
    
    override init() {
        imp = NSMutableAttributedString()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Reading Text
    override var string: String {
        get {
            return imp.string
        }
        set {
            self.replaceCharacters(in: NSMakeRange(0, imp.length), with: newValue)
        }
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
        return imp.attributes(at: location, effectiveRange: range)
    }
    
    //MARK: Text Editing
    override func replaceCharacters(in range: NSRange, with str: String) {
        imp.replaceCharacters(in: range, with: str)
        self.edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
    }
    
    /// 设置 textView 的 text，会调用这个方法
    override func replaceCharacters(in range: NSRange, with attrString: NSAttributedString) {
        imp.replaceCharacters(in: range, with: attrString)
        
        // Notifies and records a recent change.  If there are no outstanding -beginEditing calls, this method calls -processEditing to trigger post-editing processes.  This method has to be called by the primitives after changes are made if subclassed and overridden.  editedRange is the range in the original string (before the edit).
        // 通知记录内容的改变，在没有实现 -beginEditing 的情况下，该方法会调用 -processEditing
        self.edited(.editedCharacters, range: range, changeInLength: attrString.length - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
        imp.setAttributes(attrs, range: range)
        
        // Notifies and records a recent change.  If there are no outstanding -beginEditing calls, this method calls -processEditing to trigger post-editing processes.  This method has to be called by the primitives after changes are made if subclassed and overridden.  editedRange is the range in the original string (before the edit).
        self.edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    //MARK: Syntax Highlight
    // 每次文本存储有修改时，这个方法都自动被调用。每次编辑后，NSTextStorage 会用这个方法来清理字符串。
    // 例如，有些字符无法用选定的字体显示时，Text Storage 使用一个可以显示它们的字体来进行替换。
    override func processEditing() {
        // Clear text color of edited range
        let paragaphRange = (self.string as NSString).paragraphRange(for: self.editedRange)
        self.removeAttribute(.foregroundColor, range: paragaphRange)
        self.removeAttribute(.underlineStyle, range: paragaphRange)
        
        expression.enumerateMatches(in: self.string, options: [], range: paragaphRange) { (result, flags, stop) in
            guard let result = result else { return }
            // Add red highlight color
            self.addAttribute(.foregroundColor, value: UIColor.red, range: result.range)
            self.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: result.range)
        }
        
        // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
        super.processEditing()
    }
    
}
