//
//  ViewController.swift
//  SwifterDemo
//
//  Created by YZF on 1/9/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UploadDelegate {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var address: UILabel!
    
    let uploaderServer = UploadServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path)
        
        address.text = "http://\(WifiUtils.getWiFiAddress() ?? "0.0.0.0"):8080"
        result.text = ""
        
        uploaderServer.delegate = self
        
        do {
            try uploaderServer.server.start(8080)
        } catch {
            print("Server start error: \(error)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillDisappear(_ animated: Bool) {
        uploaderServer.server.stop()
    }
    
    func didUploade(fileName: String, size: String) {
        DispatchQueue.main.async {
            self.result.text = "\(fileName) 上传成功, 地址为沙盒 Caches 目录"
        }
    }
    
}

