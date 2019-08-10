//
//  VisionBarcodesViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/6/6.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Vision

class VisionBarcodesViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = UIImage(named: "QRCode")

        observation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observation() {
        guard let image = self.image else {
            return
        }
        // 获取 ciImage
        let ciImage = CIImage(image: image)!
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // VNDetectFaceRectanglesRequest 为人脸矩形识别 ⚠️⚠️⚠️
        let request = VNDetectBarcodesRequest { (vnRequest, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                self.drawBox(with: vnRequest)
            }
        }
        
        // 支持的条形码类型，默认支持所有
//        request.symbologies = [.Aztec, .code128];
        
        // 子线程进行人脸识别
        DispatchQueue.global().async {
            do {
                try requestHandler.perform([request])
            } catch {
            }
        }
        
    }
    
    func drawBox(with vnRequset: VNRequest) {
        // 转换为 VNBarcodeObservation
        if let observations = vnRequset.results as? [VNBarcodeObservation] {

            for observation in observations {
                // boundingBox 是针对 image 上 rect 的百分比⚠️⚠️⚠️ ，以左下角为坐标原点⚠️⚠️⚠️，需要转换成 imageView 上的 rect 画框框
                let boundingBox = observation.boundingBox
                
                // 回到主线程画框框
                DispatchQueue.main.async {
                    self.messageLabel.text = "条形码信息:\(observation.barcodeDescriptor.debugDescription)\n二维码信息:\(observation.payloadStringValue ?? "")"
                    self.imageView.image = UIImage.drawBox(in: self.image!, boundingBox: boundingBox)
                }
            }
        }
    }

}
