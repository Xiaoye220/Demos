//
//  VisionFaceLandmarksViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/4/8.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Vision

/// 脸部特征识别
class VisionFaceLandmarksViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let ciImage = CIImage(image: image)!
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // VNDetectFaceLandmarksRequest 特征识别的 request ⚠️⚠️⚠️
        let request = VNDetectFaceLandmarksRequest { (vnRequest, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                self.drawBox(with: vnRequest)
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
    
    func drawBox(with vnRequset: VNRequest) {
        if let observations = vnRequset.results as? [VNFaceObservation] {
            
            // 一个人脸识别对应一个 observation
            for observation in observations {
                // boundingBox 是针对 image 上 rect 的百分比⚠️⚠️⚠️ ，以左下角为坐标原点⚠️⚠️⚠️，需要转换成 imageView 上的 rect 画框框
                let boundingBox = observation.boundingBox
                
                // 用于存储所有的点的 CGPoint
                var points: [[CGPoint]] = []
                
                // 获取细节特征
                if let landmarks = observation.landmarks {
                    // 获取 脸部轮廓、眼、眉毛、鼻、嘴唇 point，为 VNFaceLandmarkRegion2D 类型
                    if let faceContour = landmarks.faceContour,
                        let leftEye = landmarks.leftEye,
                        let rightEye = landmarks.rightEye,
                        let leftEyebrow = landmarks.leftEyebrow,
                        let rightEyebrow = landmarks.rightEyebrow,
                        let nose = landmarks.nose,
                        let outerLips = landmarks.outerLips {
                        points.append(faceContour.normalizedPoints)
                        points.append(leftEye.normalizedPoints)
                        points.append(rightEye.normalizedPoints)
                        points.append(leftEyebrow.normalizedPoints)
                        points.append(rightEyebrow.normalizedPoints)
                        points.append(nose.normalizedPoints)
                        points.append(outerLips.normalizedPoints)
                    }
                }
                // 回到主线程画框框
                DispatchQueue.main.async {
                    self.imageView.image = UIImage.drawPoints(in: self.image!, points: points, boundingBox: boundingBox)
                }
            }
        }
    }

}
