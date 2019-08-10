//
//  CoreMLViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/6/9.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class CoreMLViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image = UIImage(named: "Eiffel")
        self.prediction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prediction() {
        let model = GoogLeNetPlaces()
        
        guard let image = self.image?.scale(to: CGSize(width: 224, height: 224))  else {
            return
        }
        guard let pixelBuffer = image.pixelBuffer() else {
            return
        }
        
        guard let output = try? model.prediction(sceneImage:pixelBuffer) else {
            return
        }
        
        let probs = output.sceneLabelProbs
            .sorted { (dict1, dict2) -> Bool in
                return dict2.value < dict1.value
            }.filter { (_, value) -> Bool in
                return value >= 0.01
            }.map { (key, value) in
                return (key, String(format: "%0.2f", value))
        }
        
        self.messageLabel.text = "sceneLabelProbs: \(probs)\nsceneLabel: \(output.sceneLabel)"
        
        print(probs)
    }
    
}
