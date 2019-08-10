//
//  FilmingView.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/25.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit

protocol WeiXinFilmingViewDelegate: class {
    func filmingViewDidTaped()
    func filmingViewDidBeginLongPress()
    func filmingViewDidEndLongPress()
}

class WeiXinFilmingView: UIView {

    var behindcCircular: UIView!
    var frontCircular: UIView!
    var progress: CAShapeLayer!
    
    weak var delegate: WeiXinFilmingViewDelegate!
    
    let totalSeconds: Double = 10.00
    var filemingSeconds: Double = 0
    //进度条计时器时间间隔
    var incInterval: TimeInterval = 0.05
    //进度条计时器
    var progressTimer: Timer?
    
    let behindcCircularScale: CGFloat = 1.4
    let frontCircularScale: CGFloat = 0.8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        
        behindcCircular = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        behindcCircular.center = self.center
        behindcCircular.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        behindcCircular.layer.cornerRadius = behindcCircular.frame.width / 2
        self.addSubview(behindcCircular)
        
        frontCircular = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        frontCircular.center = self.center
        frontCircular.backgroundColor = UIColor.white
        frontCircular.layer.cornerRadius = frontCircular.frame.width / 2
        frontCircular.layer.shadowColor = UIColor.black.cgColor
        frontCircular.layer.shadowOffset = CGSize.zero
        frontCircular.layer.shadowRadius = 5
        frontCircular.layer.shadowOpacity = 0.1
        self.addSubview(frontCircular)
        
        let progressRadius = 75 * behindcCircularScale - 5
        progress = CAShapeLayer()
        progress.frame = CGRect(x: 0, y: 0, width: progressRadius, height: progressRadius)
        progress.position = self.center
        progress.lineWidth = 5
        progress.strokeColor = #colorLiteral(red: 0, green: 0.6680376838, blue: 0, alpha: 1).cgColor
        //progress.lineCap = kCALineCapRound
        progress.fillColor = UIColor.clear.cgColor
        progress.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: progressRadius, height: progressRadius)).cgPath
        progress.strokeStart = 0
        progress.strokeEnd = 0
        progress.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0, 0, 1)
        progress.isHidden = true
        self.layer.addSublayer(progress)
    }
    
    func setGestureRecognizer() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(_:)))
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(_:)))
        longPress.minimumPressDuration = 1.0
        
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longPress)
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.frontCircular.transform = CGAffineTransform(scaleX: self.frontCircularScale, y: self.frontCircularScale)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.frontCircular.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                self.delegate?.filmingViewDidTaped()
            })
        })
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.2, animations: {
                self.behindcCircular.transform = CGAffineTransform(scaleX: self.behindcCircularScale, y: self.behindcCircularScale)
                self.frontCircular.transform = CGAffineTransform(scaleX: self.frontCircularScale, y: self.frontCircularScale)
            }, completion: { _ in
                self.delegate?.filmingViewDidBeginLongPress()
            })
        case .ended:
            self.delegate?.filmingViewDidEndLongPress()
            behindcCircular.transform = CGAffineTransform(scaleX: 1, y: 1)
            frontCircular.transform = CGAffineTransform(scaleX: 1, y: 1)
        default:
            break
        }
    }
    
    func startProgress() {
        progress.isHidden = false
        progressTimer = Timer.scheduledTimer(withTimeInterval: incInterval, repeats: true, block: { [weak self] timer in
            guard let `self` = self else { return }
            self.filemingSeconds += self.incInterval
            self.progress.strokeEnd = CGFloat(self.filemingSeconds / self.totalSeconds)
        })
    }
    
    func stopProgress() {
        progress.isHidden = true
        progress.strokeEnd = 0
        filemingSeconds = 0
        progressTimer?.invalidate()
    }
    
}
