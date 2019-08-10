//
//  SavaPhotoViewController.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/27.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Photos

class SavePhotoViewController: UIViewController {

    var imageView: UIImageView!
    var barButton: UIBarButtonItem!
    
    //存放照片资源的标志符
    var localId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        imageView.image = UIImage(named: "1")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        barButton = UIBarButtonItem.init(title: "保存图片", style: .plain, target: self, action: #selector(savePhoto))
        self.navigationItem.rightBarButtonItem = barButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func savePhoto() {
        let image = self.imageView.image!
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            //保存标志符
            self.localId = assetPlaceholder?.localIdentifier
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                print("保存成功!")
                //通过标志符获取对应的 PHAsset
                let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [self.localId], options: nil)
                let asset = assetResult[0]
                
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                    return true
                }
                //获取保存的图片路径
                asset.requestContentEditingInput(with: options, completionHandler: {
                    (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
                    print("地址：",contentEditingInput!.fullSizeImageURL!)
                })
            } else{
                print("保存失败：", error!.localizedDescription)
            }
        }
    }

}
