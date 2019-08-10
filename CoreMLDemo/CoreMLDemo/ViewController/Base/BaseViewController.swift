//
//  BaseViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/4/8.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Vision

class BaseViewController: UIViewController, CoreMLProtocol {
    
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    var imageView: UIImageView!
    var barButton: UIBarButtonItem!
    var messageLabel: UILabel!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        imageView = UIImageView(frame: CGRect(x: 0, y: topHeight, width: screenWidth, height: screenWidth))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: topHeight + screenWidth + 50, width: screenWidth, height: screenHeight - (topHeight + screenWidth + 50)))
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        
        barButton = UIBarButtonItem.init(title: "选择图片", style: .plain, target: self, action: #selector(pickImage))
        navigationItem.rightBarButtonItem = barButton
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imageView.contentMode = .scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pickImage() {
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func observation() {
        
    }
    
}

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        self.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        self.observation()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
