//
//  UIViewController+Extension.swift
//  MapDemo
//
//  Created by YZF on 2018/2/6.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
