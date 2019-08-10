//
//  EditView.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/27.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation

protocol WeiXinEditViewDelegate: class {
    func editViewDidTapedBackIcon()
    func editViewDidTapedAdjustIcon()
    func editViewDidTapedCheckIcon()
}

class WeiXinEditView: UIView {

    var backIcon: UIButton!
    var adjustIcon: UIButton!
    var checkIcon: UIButton!
    
    var player: AVPlayer!
    
    weak var delegate: WeiXinEditViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        adjustIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        adjustIcon.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        adjustIcon.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        adjustIcon.layer.cornerRadius = adjustIcon.frame.width / 2
        adjustIcon.iconFont(size: 30, icon: Icon.adjust, color: UIColor.black)
        adjustIcon.addTarget(self, action: #selector(onClickAdjustIcon(_:)), for: .touchUpInside)
        self.addSubview(adjustIcon)
        
        backIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        backIcon.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        backIcon.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backIcon.layer.cornerRadius = backIcon.frame.width / 2
        backIcon.iconFont(size: 30, icon: Icon.back, color: UIColor.black)
        backIcon.addTarget(self, action: #selector(onClickBackIcon(_:)), for: .touchUpInside)
        self.addSubview(backIcon)
        
        checkIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        checkIcon.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        checkIcon.backgroundColor = UIColor.white
        checkIcon.layer.cornerRadius = checkIcon.frame.width / 2
        checkIcon.iconFont(size: 30, icon: Icon.check, color: #colorLiteral(red: 0, green: 0.5176470588, blue: 0, alpha: 1))
        checkIcon.addTarget(self, action: #selector(onClickCheckIcon(_:)), for: .touchUpInside)
        self.addSubview(checkIcon)
    }
    
    @objc func onClickAdjustIcon(_ sender: UIButton) {
        delegate?.editViewDidTapedAdjustIcon()
    }
    
    @objc func onClickBackIcon(_ sender: UIButton) {
        delegate?.editViewDidTapedBackIcon()
    }

    @objc func onClickCheckIcon(_ sender: UIButton) {
        delegate?.editViewDidTapedCheckIcon()
    }

    func animation() {
        UIView.animate(withDuration: 0.5) {
            self.backIcon.center = CGPoint(x: self.frame.width / 2 - 100, y: self.frame.height / 2)
            self.checkIcon.center = CGPoint(x: self.frame.width / 2 + 100, y: self.frame.height / 2)
        }
    }
    
    func reset() {
        backIcon.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        checkIcon.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
}
