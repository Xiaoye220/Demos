//
//  PhotoKitUtils.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/22.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import Photos

class PhotoKitUtils {
    
    @available(iOS 8.0, *)
    /// 获取权限
    static func doWithPhotoAuthorized(with handler: @escaping () -> (Void)) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            handler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    handler()
                }
            }
        default:
            print("请开启相册权限")
        }
    }
    
}
