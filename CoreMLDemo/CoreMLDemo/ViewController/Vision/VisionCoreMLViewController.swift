//
//  VisionCoreMLViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/6/9.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Vision

class VisionCoreMLViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.image = UIImage(named: "Eiffel")
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
        
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
            return
        }
        
        // 获取 ciImage
        let ciImage = CIImage(image: image)!
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // VNDetectFaceRectanglesRequest 为人脸矩形识别 ⚠️⚠️⚠️
        let request = VNCoreMLRequest(model: model) { (vnRequest, error) in
            if let observations = vnRequest.results as? [VNClassificationObservation] {
                DispatchQueue.main.async {
                    self.messageLabel.text = "\(observations[0].identifier)\n\(observations[0].confidence)"
                }
            }
        }
        
        // 子线程进行人脸识别
        DispatchQueue.global().async {
            do {
                try requestHandler.perform([request])
            } catch {
            }
        }
        
    }
   

}
