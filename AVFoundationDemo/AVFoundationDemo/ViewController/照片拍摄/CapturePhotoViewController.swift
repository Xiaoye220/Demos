//
//  VideoRecordViewController.swift
//  AVFoundation
//
//  Created by YZF on 15/12/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import Photos
import AVFoundation


/// 视频录制
class CapturePhotoViewController: UIViewController {
    
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.default(for: .video)!
    //前置摄像头
    let frontVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
    
    //设备输入
    var videoInput: AVCaptureDeviceInput!
    var frontVideoInput: AVCaptureDeviceInput!
    
    /// 照片输出, ios 10 之前 AVCaptureStillImageOutput, ios 10 之后 AVCapturePhotoOutput
    let photoOutput = AVCapturePhotoOutput()
    //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
    var videoLayer: AVCaptureVideoPreviewLayer!
    //拍摄、保存按钮, dismissButton, 前后置摄像头按钮
    var shootButton, saveButton, dismissButton, changeCameraButton : UIButton!
    // 预览照片
    var capturedPhotoView: UIImageView!
    // 临时保存拍摄的照片
    var capturedPhoto: UIImage?
    // 是否处于预览状态
    var isPreview: Bool = false
    // 对焦框
    var focusFrame: UILabel!
    // 对焦框动画
    var focusFrameAnimation: CABasicAnimation!
    // 隐藏对焦框计时器
    var hiddenFocusFrameTimer: Timer?
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加视频、音频输入设备
        do {
            // 获取相机权限
            videoInput = try AVCaptureDeviceInput(device: self.videoDevice)
            frontVideoInput = try AVCaptureDeviceInput(device: self.frontVideoDevice)
            self.captureSession.addInput(videoInput)
        } catch {
            print("添加视频输入设备失败")
        }
        
        //添加视频捕获输出
        self.captureSession.addOutput(self.photoOutput)
        
        //创建按钮
        self.setupView()
        //启动session会话
        self.captureSession.startRunning()
    }
    
    
    //创建按钮
    func setupView(){
        videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        capturedPhotoView = UIImageView(frame: self.view.bounds)
        capturedPhotoView.isHidden = true
        self.view.addSubview(capturedPhotoView)
        
        //创建拍摄按钮
        self.shootButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
        self.shootButton.backgroundColor = UIColor.red
        self.shootButton.layer.masksToBounds = true
        self.shootButton.setTitle("拍摄", for: .normal)
        self.shootButton.layer.cornerRadius = 20.0
        self.shootButton.layer.position = CGPoint(x:self.view.bounds.width/2 - 70,
                                                  y:self.view.bounds.height-50)
        self.shootButton.addTarget(self, action: #selector(onClickShootButton(_:)),
                                   for: .touchUpInside)
        
        //创建保存按钮
        self.saveButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
        self.saveButton.backgroundColor = UIColor.gray
        self.saveButton.layer.masksToBounds = true
        self.saveButton.setTitle("保存", for: .normal)
        self.saveButton.layer.cornerRadius = 20.0
        
        self.saveButton.layer.position = CGPoint(x: self.view.bounds.width/2 + 70,
                                                 y:self.view.bounds.height-50)
        self.saveButton.addTarget(self, action: #selector(onClickSaveButton(_:)),
                                  for: .touchUpInside)
        
        self.dismissButton = UIButton(frame: CGRect(x:20,y:30,width:30,height:30))
        self.dismissButton.iconFont(size: 30, icon: Icon.dismiss, color: .white)
        self.dismissButton.addTarget(self, action: #selector(onClickDismissButton(_:)),
                                     for: .touchUpInside)
        
        self.changeCameraButton = UIButton(frame: CGRect(x: self.view.bounds.width - 50,y:30,width:30,height:30))
        self.changeCameraButton.iconFont(size: 30, icon: Icon.camera, color: .white)
        self.changeCameraButton.addTarget(self, action: #selector(onClickChangeCameraButton(_:)),
                                     for: .touchUpInside)
        
        //添加按钮到视图上
        self.view.addSubview(self.shootButton)
        self.view.addSubview(self.saveButton)
        self.view.addSubview(self.dismissButton)
        self.view.addSubview(self.changeCameraButton)
        
        // 点击对焦，显示对焦框
        let tap = UITapGestureRecognizer(target: self, action: #selector(focusPointOfInterest(_:)))
        self.view.addGestureRecognizer(tap)
        
        self.focusFrame = UILabel(frame: CGRect(x:0,y:0,width:50,height:50))
        self.focusFrame.iconFont(size: 50, icon: Icon.focus, color: #colorLiteral(red: 0, green: 0.5176470588, blue: 0, alpha: 1))
        self.focusFrame.isHidden = true
        self.view.addSubview(self.focusFrame)
        
        self.focusFrameAnimation = CABasicAnimation(keyPath: "transform.scale")
        self.focusFrameAnimation.duration = 0.2
        self.focusFrameAnimation.repeatCount = 1
        self.focusFrameAnimation.fromValue = 1.4
        self.focusFrameAnimation.toValue = 1
    }
    
    //拍摄按钮点击，拍摄照片
    @objc func onClickShootButton(_ sender: UIButton) {
        if isPreview {
            // 退出预览
            self.capturedPhotoView.isHidden = true
            //按钮颜色改变
            self.shootButton.setTitle("拍摄", for: .normal)
            self.changeButtonColor(target: self.shootButton, color: .red)
            self.changeButtonColor(target: self.saveButton, color: .gray)
            isPreview = false
        } else {
            //对视频输入截图当照片
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
            //按钮改变
            self.shootButton.setTitle("取消", for: .normal)
            self.changeButtonColor(target: self.shootButton, color: .gray)
            self.changeButtonColor(target: self.saveButton, color: .red)
            isPreview = true
        }
    }
    
    //保存按钮点击，保存照片
    @objc func onClickSaveButton(_ sender: UIButton){
        if isPreview {
            var message:String!
            //将拍摄好的照片保存到照片库中
            PHPhotoLibrary.shared().performChanges({
                if let capturedPhoto = self.capturedPhoto {
                    PHAssetChangeRequest.creationRequestForAsset(from: capturedPhoto)
                }
            }, completionHandler: { (isSuccess: Bool, error: Error?) in
                if isSuccess { message = "保存成功!" }
                else{ message = "保存失败：\(error!.localizedDescription)" }
                
                DispatchQueue.main.async {
                    //弹出提示框
                    let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            // 退出预览
            self.capturedPhotoView.isHidden = true
            //按钮颜色改变
            self.shootButton.setTitle("拍摄", for: .normal)
            self.changeButtonColor(target: self.shootButton, color: .red)
            self.changeButtonColor(target: self.saveButton, color: .gray)
            isPreview = false
        }
    }
    
    //dismiss ViewController
    @objc func onClickDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 对焦
    @objc func focusPointOfInterest(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        // 将一个点从 Layer 坐标转换为 captureDevice 的空间
        // 如屏幕大小 375*667  (375,667) -> (1.0,1.0)   (100,200) -> (100/375,200/667)
        let focusPoint = videoLayer.captureDevicePointConverted(fromLayerPoint: point)

        self.focusFrame.isHidden = false
        self.focusFrame.center = point
        self.focusFrame.layer.add(focusFrameAnimation, forKey: nil)
        self.hiddenFocusFrameTimer?.invalidate()
        hiddenFocusFrameTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] timer in
            self?.focusFrame.isHidden = true
            timer.invalidate()
        }
        
        do {
            // 要改变相机设置（对焦、曝光等）前需要 lock 当前设备，完成设置后 unlock
            try videoDevice.lockForConfiguration()
            if videoDevice.isFocusModeSupported(.autoFocus) {
                videoDevice.focusMode = .autoFocus
                videoDevice.focusPointOfInterest = focusPoint
            }
            videoDevice.unlockForConfiguration()
        } catch {
            
        }
    }
    
    // 前后置相机转换
    @objc func onClickChangeCameraButton(_ sender: UIButton) {
        if self.captureSession.inputs.contains(videoInput) {
            self.captureSession.removeInput(videoInput)
            self.captureSession.addInput(frontVideoInput)
        } else {
            self.captureSession.removeInput(frontVideoInput)
            self.captureSession.addInput(videoInput)
        }
    }
    
    //修改按钮的颜色
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
}

extension CapturePhotoViewController: AVCapturePhotoCaptureDelegate {
    
    @available(iOS 11.0, *)
    /// iOS 11.0 获取拍摄的照片
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image =  UIImage(data: imageData)
        showCapturedPhoto(image)
    }
    
    /// iOS 10.0 之前获取拍摄的照片
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let image =  UIImage(data: imageData)
            showCapturedPhoto(image)
        }
    }
    
    /// 拍摄成功预览照片
    func showCapturedPhoto(_ image: UIImage?) {
        guard var image = image else { return }
        // 前置摄像头拍摄的照片需要将图像左右翻转
        if self.captureSession.inputs.contains(frontVideoInput) {
            image = UIImage.init(cgImage: image.cgImage!, scale: 1, orientation: .leftMirrored)
        }
        //预览照片
        capturedPhoto = image
        capturedPhotoView.isHidden = false
        capturedPhotoView.image = image
    }
}



