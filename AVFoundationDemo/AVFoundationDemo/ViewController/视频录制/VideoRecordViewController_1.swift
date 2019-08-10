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
class VideoRecordViewController_1: UIViewController {
    
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.default(for: .video)
    //音频输入设备
    let audioDevice = AVCaptureDevice.default(for: .audio)
    //将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    
    //开始、停止按钮, dismissButton
    var startButton, stopButton, dismissButton : UIButton!
    //表示当时是否在录像中
    var isRecording = false
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加视频、音频输入设备
        do {
            // 获取相机权限
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!)
            self.captureSession.addInput(videoInput)
            // 获取麦克风权限
            let audioInput = try AVCaptureDeviceInput(device: self.audioDevice!)
            self.captureSession.addInput(audioInput)
        } catch {
            print("添加视频、音频输入设备失败")
        }
        
        //添加视频捕获输出
        self.captureSession.addOutput(self.fileOutput)
        
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        //创建按钮
        self.setupButton()
        //启动session会话
        self.captureSession.startRunning()
    }
    
    
    //创建按钮
    func setupButton(){
        //创建开始按钮
        self.startButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
        self.startButton.backgroundColor = UIColor.red
        self.startButton.layer.masksToBounds = true
        self.startButton.setTitle("开始", for: .normal)
        self.startButton.layer.cornerRadius = 20.0
        self.startButton.layer.position = CGPoint(x:self.view.bounds.width/2 - 70,
                                                  y:self.view.bounds.height-50)
        self.startButton.addTarget(self, action: #selector(onClickStartButton(_:)),
                                   for: .touchUpInside)
        
        //创建停止按钮
        self.stopButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
        self.stopButton.backgroundColor = UIColor.gray
        self.stopButton.layer.masksToBounds = true
        self.stopButton.setTitle("停止", for: .normal)
        self.stopButton.layer.cornerRadius = 20.0
        
        self.stopButton.layer.position = CGPoint(x: self.view.bounds.width/2 + 70,
                                                 y:self.view.bounds.height-50)
        self.stopButton.addTarget(self, action: #selector(onClickStopButton(_:)),
                                  for: .touchUpInside)
        
        self.dismissButton = UIButton(frame: CGRect(x:20,y:30,width:30,height:30))
        self.dismissButton.iconFont(size: 30, icon: Icon.dismiss, color: .white)
        self.dismissButton.addTarget(self, action: #selector(onClickDismissButton(_:)),
                                     for: .touchUpInside)
        
        //添加按钮到视图上
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.stopButton)
        self.view.addSubview(self.dismissButton)
    }
    
    //开始按钮点击，开始录像
    @objc func onClickStartButton(_ sender: UIButton) {
        if !self.isRecording {
            //设置录像的保存地址（在Documents目录下，名为temp.mp4）
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath = "\(documentsDirectory)/temp.mp4"
            let fileURL = URL(fileURLWithPath: filePath)
            //启动视频编码输出
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)
            
            //记录状态：录像中...
            self.isRecording = true
            //开始、结束按钮颜色改变
            self.changeButtonColor(target: self.startButton, color: .gray)
            self.changeButtonColor(target: self.stopButton, color: .red)
        }
    }
    
    //停止按钮点击，停止录像
    @objc func onClickStopButton(_ sender: UIButton){
        if self.isRecording {
            //停止视频编码输出
            fileOutput.stopRecording()
            
            //记录状态：录像结束
            self.isRecording = false
            //开始、结束按钮颜色改变
            self.changeButtonColor(target: self.startButton, color: .red)
            self.changeButtonColor(target: self.stopButton, color: .gray)
        }
    }
    
    //dismiss ViewController
    @objc func onClickDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //修改按钮的颜色
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
}

extension VideoRecordViewController_1: AVCaptureFileOutputRecordingDelegate {
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {

    }
    
    //录像结束的代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        var message:String!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                message = "保存成功!"
            } else{
                message = "保存失败：\(error!.localizedDescription)"
            }
            
            DispatchQueue.main.async {
                //弹出提示框
                let alertController = UIAlertController(title: message, message: nil,
                                                        preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

