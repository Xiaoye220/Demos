//
//  WeiXinCameraViewController.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/25.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class WeiXinCameraViewController: UIViewController {

    ///视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    ///视频输入设备
    let videoDevice = AVCaptureDevice.default(for: .video)
    ///音频输入设备
    let audioDevice = AVCaptureDevice.default(for: .audio)
    ///将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    /// 照片输出, ios 10 之前 AVCaptureStillImageOutput, ios 10 之后 AVCapturePhotoOutput
    let photoOutput = AVCapturePhotoOutput()
    ///最大允许的录制时间（秒）
    let totalSeconds: Float64 = 10.00
    ///剩余时间计时器
    var timer: Timer?
    /// 预览拍摄视频
    var player: AVPlayer?
    /// 临时保存拍摄的照片
    var capturedPhoto: UIImage?
    /// 拍摄视频存储地址
    let videoTmpUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("videoTmp.mp4")
    
    /// 拍摄按钮
    var filmingView: WeiXinFilmingView!
    /// 拍摄完成后三个选择按钮
    var editView: WeiXinEditView!
    var dismissButton: UIButton!
    
    /// 用于预览视频
    var playerLayer: AVPlayerLayer!
    /// 预览照片
    var capturedPhotoView: UIImageView!
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
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
        self.captureSession.addOutput(self.photoOutput)
        
        self.setupView()
        
        //启动session会话
        self.captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        playerLayer = AVPlayerLayer()
        playerLayer.frame = self.view.bounds
        playerLayer.isHidden = true
        self.view.layer.addSublayer(playerLayer)
        
        capturedPhotoView = UIImageView(frame: self.view.bounds)
        capturedPhotoView.isHidden = true
        self.view.addSubview(capturedPhotoView)
        
        filmingView = WeiXinFilmingView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        filmingView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 80)
        filmingView.delegate = self
        self.view.addSubview(filmingView)
        
        editView = WeiXinEditView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        editView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 80)
        editView.isHidden = true
        editView.delegate = self
        self.view.addSubview(editView)
        
        dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dismissButton.center = CGPoint(x: view.bounds.width / 4, y: view.bounds.height - 80)
        dismissButton.addTarget(self, action: #selector(onClickDismissButton(_:)),for: .touchUpInside)
        dismissButton.iconFont(size: 30, icon: Icon.dismiss, color: .white)
        self.view.addSubview(dismissButton)
    }
    
    @objc func onClickDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WeiXinCameraViewController: WeiXinFilmingViewDelegate {
    /// 点击拍摄按钮，进行拍照
    func filmingViewDidTaped() {
        photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    /// 开始长按拍摄按钮，进行录像
    func filmingViewDidBeginLongPress() {
        //启动视频编码输出
        fileOutput.startRecording(to: videoTmpUrl, recordingDelegate: self)
    }
    
    /// 结束长按拍摄按钮，结束录像
    func filmingViewDidEndLongPress() {
        stopFilming()
    }
    
    func stopFilming() {
        fileOutput.stopRecording()
        filmingView.isHidden = true
        filmingView.stopProgress()
        timer?.invalidate()
    }
}

extension WeiXinCameraViewController: WeiXinEditViewDelegate {
    /// 点击返回按钮，退出编辑状态
    func editViewDidTapedBackIcon() {
        stopEdit()
    }
    /// 点击编辑按钮，对视频照片进行编辑，未实现
    func editViewDidTapedAdjustIcon() {
        
    }
    /// 点击确认按钮，进行保存并退出编辑状态
    func editViewDidTapedCheckIcon() {
        save()
        stopEdit()
    }
    
    func stopEdit() {
        dismissButton.isHidden = false
        editView.isHidden = true
        editView.reset()
        filmingView.isHidden = false
        
        playerLayer.isHidden = true
        NotificationCenter.default.removeObserver(self)
        capturedPhotoView.isHidden = true
        capturedPhoto = nil
    }
    
    func save() {
        var message: String!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            if let capturedPhoto = self.capturedPhoto {
                PHAssetChangeRequest.creationRequestForAsset(from: capturedPhoto)
            }
            if FileManager.default.fileExists(atPath: self.videoTmpUrl.path) {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoTmpUrl)
            }
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                message = "保存成功!"
                // 若有缓存本地的视频，则删除
                if FileManager.default.fileExists(atPath: self.videoTmpUrl.path) {
                    do {
                        try FileManager.default.removeItem(at: self.videoTmpUrl)
                    } catch { }
                }
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

extension WeiXinCameraViewController: AVCaptureFileOutputRecordingDelegate {
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        timer = Timer.scheduledTimer(withTimeInterval: totalSeconds, repeats: false, block: { [weak self] timer in self?.stopFilming() })
        filmingView.startProgress()
        dismissButton.isHidden = true
    }
    
    //录像结束的代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        editView.isHidden = false
        editView.animation()
        playVideo()
    }
    
    /// 预览录像
    func playVideo() {
        playerLayer.isHidden = false
        
        let playerItem = AVPlayerItem(url: videoTmpUrl)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        player?.play()
    }
    
    /// 视频播放完毕响应，重新播放
    @objc func playerDidFinishPlaying(_ notification: NSNotification) {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero)
        player?.play()
    }

}

extension WeiXinCameraViewController: AVCapturePhotoCaptureDelegate {
    
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
        guard let image = image else { return }
        dismissButton.isHidden = true
        filmingView.isHidden = true
        capturedPhoto = image
        capturedPhotoView.isHidden = false
        capturedPhotoView.image = image
        editView.isHidden = false
        editView.animation()
    }
}
