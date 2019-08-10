//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/4/8.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    enum Content: String {
        case Vision_face = "Vision 人脸识别"
        case Vision_faceLandmarks = "Vision 特征识别"
        case Vision_text = "Vision 文字识别"
        case Vision_barcodes = "Vision 二维码识别"
        case Vision_CoreML = "Vision CoreML"
        case CoreML_GoogLeNetPlaces = "CoreML GoogLeNetPlaces"
    }
    
    var contents: [[Content]] = [[.Vision_face, .Vision_faceLandmarks, .Vision_text, .Vision_barcodes, .Vision_CoreML], [.CoreML_GoogLeNetPlaces]]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "default")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = contents[indexPath.section][indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        var controller: BaseViewController!
        switch content {
        case .Vision_face:
            controller = VisionFaceViewController()
        case .Vision_faceLandmarks:
            controller = VisionFaceLandmarksViewController()
        case .Vision_text:
            controller = VisionTextViewController()
        case .Vision_barcodes:
            controller = VisionBarcodesViewController()
        case .Vision_CoreML:
            controller = VisionCoreMLViewController()
        case .CoreML_GoogLeNetPlaces:
            controller = CoreMLViewController()
        }
        controller.image = imageView.image
        controller.navigationItem.title = content.rawValue
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

