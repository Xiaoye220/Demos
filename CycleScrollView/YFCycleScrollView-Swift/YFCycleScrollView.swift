//
//  CustomPageControl.swift
//  CustomPageControl-Swift
//
//  Created by Xiaoye on 31/3/17.
//
//

import UIKit


public class YFCycleScrollView: UIView {
    
    private let goldenSection: CGFloat  = 0.618
    private var leftImageView: Int { get { return (currentImageView + 3) % 4 } }
    private var centerImageView: Int { get { return currentImageView } }
    private var rightImageView: Int { get { return (currentImageView + 1) % 4 } }
    private var newImageView: Int { get { return (currentImageView + 2) % 4 } }
    
    private var leftPage: Int { get {return (currentPage + pageNum - 1) % pageNum} }
    private var rightPage: Int { get {return (currentPage + 1) % pageNum} }

    
    private var transform_right = CATransform3DIdentity
    private var transform_left = CATransform3DIdentity
    private var transform_center = CATransform3DIdentity
    
    private var currentImageView = 0
    private var pageNum: Int!
    
    private var imageViews: [UIImageView] = []
    private var imageNamed: [String]!
    
    private var pageControl: UIPageControl!
    
    private var viewWidth: CGFloat { return bounds.size.width }
    private var viewHeight: CGFloat { return bounds.size.height }
    
    private var timer = Timer()
    
    private var currentPage = 0
    private var isRightScrolling = false
    private var isLeftScrolling = false

    public var timeInterval: TimeInterval = 3 {
        didSet {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(leftScroll), userInfo: nil, repeats: true)
        }
    }
    public var tapHandle: ((_ index: Int) -> Void)?
    public var pageControlTintColor: UIColor? {
        didSet {
            pageControl.pageIndicatorTintColor = pageControlTintColor
        }
    }
    
    public var pageControlCurrentPageTintColor: UIColor? {
        didSet {
            pageControl.currentPageIndicatorTintColor = pageControlCurrentPageTintColor
        }
    }
    
    public init(frame: CGRect, imageNamed: [String]) {
        super.init(frame: frame)
        pageNum = imageNamed.count
        self.imageNamed = imageNamed
        
        loadData()
        buildView()
        startScroll()
    }
    
    private func loadData() {
        //m11（x缩放）  m12（y切变）  m13（旋转）   m14（）
        //m21（x切变）  m22（y缩放）  m23（）      m24（）
        //m31（旋转）   m32 ()       m33（）      m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）
        //m41（x平移）  m42（y平移）  m43（z平移）  m44（）
        transform_right.m34 = -0.002
        transform_right.m11 = 0.7
        transform_right.m22 = 0.7
        transform_right.m41 = viewWidth*3/10
        
        transform_left.m34 = -0.002
        transform_left.m11 = 0.7
        transform_left.m22 = 0.7
        transform_left.m41 = -1 * viewWidth*3/10
        
        //transform_left.m34 = -0.002
        transform_center.m11 = 1
        transform_center.m22 = 1
        transform_center.m41 = 0
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipes(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        leftSwipeGestureRecognizer.direction = .left
        rightSwipeGestureRecognizer.direction = .right
        
        addGestureRecognizer(leftSwipeGestureRecognizer)
        addGestureRecognizer(rightSwipeGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func buildView() {
        for _ in 0 ..< 4 {
            let imageView = UIImageView.init(frame: CGRect.init(x: viewWidth/5, y: 20, width: viewWidth*3/5, height: goldenSection*viewWidth*3/5))
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            imageView.layer.allowsEdgeAntialiasing = true
            imageViews.append(imageView)
        }
        imageViews[centerImageView].image = UIImage.init(named: imageNamed[currentPage])
        imageViews[leftImageView].image = UIImage.init(named: imageNamed[leftPage])
        imageViews[rightImageView].image = UIImage.init(named: imageNamed[rightPage])
        
        imageViews[leftImageView].layer.transform = CATransform3DRotate(transform_left, CGFloat(30*Double.pi/180), 0, 1, 0);
        addSubview(imageViews[leftImageView])
        
        imageViews[rightImageView].layer.transform = CATransform3DRotate(transform_right, CGFloat(-30*Double.pi/180), 0, 1, 0);
        addSubview(imageViews[rightImageView])
        
        
        addSubview(imageViews[currentImageView])
        
        //pageControl
        pageControl = UIPageControl()
        pageControl.numberOfPages = pageNum;
        let pagerSize = pageControl.size(forNumberOfPages: pageNum)
        pageControl.bounds = CGRect.init(x: 0, y: 0, width: pagerSize.width, height: pagerSize.height)
        pageControl.center = CGPoint.init(x: viewWidth / 2, y: viewHeight - 15)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        //pageControl.addTarget(self, action: #selector(), for: .valueChanged)
        
        addSubview(pageControl)
    }
    
    private func rightScroll() {
        if isLeftScrolling || isRightScrolling  {
            return
        }
        isRightScrolling = true
        imageViews[newImageView].image = UIImage.init(named: imageNamed[(currentPage + pageNum - 2) % pageNum])
        imageViews[newImageView].layer.transform = CATransform3DRotate(transform_left, CGFloat(30*Double.pi/180), 0, 1, 0);
        imageViews[newImageView].alpha = 0;
        addSubview(imageViews[newImageView])
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.imageViews[self.centerImageView].layer.transform = CATransform3DRotate(self.transform_right, CGFloat(-30*Double.pi/180), 0, 1, 0);
            self.imageViews[self.leftImageView].layer.transform = CATransform3DRotate(self.transform_center, 0, 0, 0, 0);
            self.imageViews[self.newImageView].alpha = 1;
            self.imageViews[self.rightImageView].alpha = 0;
        }) { finished in
            self.currentImageView = self.leftImageView;
            self.currentPage = self.leftPage;
            self.pageControl.currentPage = self.currentPage;
            self.startScroll()
            self.isRightScrolling = false
        }
        
    }
    
    @objc private func leftScroll() {
        if isLeftScrolling || isRightScrolling  {
            return
        }
        isLeftScrolling = true
        imageViews[newImageView].image = UIImage.init(named: imageNamed[(currentPage + pageNum + 2) % pageNum])
        imageViews[newImageView].layer.transform = CATransform3DRotate(transform_right, CGFloat(-30*Double.pi/180), 0, 1, 0);
        imageViews[newImageView].alpha = 0;
        addSubview(imageViews[newImageView])
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imageViews[self.centerImageView].layer.transform = CATransform3DRotate(self.transform_left, CGFloat(30*Double.pi/180), 0, 1, 0);
            self.imageViews[self.rightImageView].layer.transform = CATransform3DRotate(self.transform_center, 0, 0, 0, 0);
            self.imageViews[self.newImageView].alpha = 1;
            self.imageViews[self.leftImageView].alpha = 0;
        }) { (finished) in
            self.currentImageView = self.rightImageView;
            self.currentPage = self.rightPage;
            self.pageControl.currentPage = self.currentPage;
            self.startScroll()
            self.isLeftScrolling = false
        }
    }
    
    @objc private func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        stopScroll()
        if sender.direction == .left {
            leftScroll()
        } else if sender.direction == .right {
            rightScroll()
        }
    }
    
    @objc private func handleTap(_ sender:UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if point.x < viewWidth / 5 {
            stopScroll()
            rightScroll()
        } else if point.x > viewWidth * 4 / 5 {
            stopScroll()
            leftScroll()
        } else {
            if let tapHandle = tapHandle {
                tapHandle(currentPage)
            }
        }
    }
    
    private func startScroll() {
        if(!timer.isValid) {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(leftScroll), userInfo: nil, repeats: true)
        }
    }
    private func stopScroll() {
        timer.invalidate()
    }
    
    deinit {
        timer.invalidate()
    }
   
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
