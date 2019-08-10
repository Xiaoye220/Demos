//
//  DemoViewController_1.swift
//  ARKitDemo
//
//  Created by YZF on 2018/7/23.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class DemoViewController_1: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        sceneView = ARSCNView(frame: CGRect(x: 0, y: topHeight, width: screenWidth, height: screenHeight))
        self.view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        sceneView.session.pause()
    }
    
    

}
