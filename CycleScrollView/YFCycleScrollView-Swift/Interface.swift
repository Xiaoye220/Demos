//
//  Interface.swift
//  YFCycleScrollView-Swift
//
//  Created by Xiaoye on 16/6/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

public protocol YFCycleScrollViewInterface : class {
    
    var timeInterval: TimeInterval { get set }
    
    var tapHandle: ((_ index: Int) -> Void)? { get set }
    
    var pageControlTintColor: UIColor? { get set }
    
    var pageControlCurrentPageTintColor: UIColor? { get set }
    
    init(frame: CGRect, imageNamed: [String])
    
}
