//
//  VisionTextViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/5/26.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Vision

class VisionTextViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = UIImage(named: "text")
        
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
        
        // VNDetectTextRectanglesRequest 文字识别的 request ⚠️⚠️⚠️
        let request = VNDetectTextRectanglesRequest { (vnRequest, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                self.drawBox(with: vnRequest)
            }
        }
        // 可以识别单个字符，false则识别整行字符
        request.reportCharacterBoxes = true
        
        // 子线程进行人脸识别
        DispatchQueue.global().async {
            do {
                try requestHandler.perform([request])
            } catch {
            }
        }
    }
    
    func drawBox(with vnRequset: VNRequest) {
        if let observations = vnRequset.results as? [VNTextObservation] {
            // 一个文字识别对应一个 observation
            for observation in observations {
                // boundingBox 是针对 image 上 rect 的百分比⚠️⚠️⚠️ ，以左下角为坐标原点⚠️⚠️⚠️，需要转换成 imageView 上的 rect 画框框
                let boundingBox = observation.boundingBox
                // 回到主线程画框框
                DispatchQueue.main.async {
                    self.imageView.image = UIImage.drawBox(in: self.imageView.image!, boundingBox: boundingBox)
                }
                
                // 识别单个 字符
                if let characterBoxes = observation.characterBoxes {
                    for chatacter in characterBoxes {
                        let boundingBox = chatacter.boundingBox
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage.drawBox(in: self.imageView.image!, boundingBox: boundingBox)
                        }
                    }
                }
            }
        }
    }
}
