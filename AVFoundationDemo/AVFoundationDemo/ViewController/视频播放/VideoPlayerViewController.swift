//
//  VideoPlayerViewController.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/28.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    //播放按钮
    @IBOutlet weak var playButton: UIButton!
    
    //可拖动的进度条
    @IBOutlet weak var playbackSlider: UISlider!
    
    //当前播放时间标签
    @IBOutlet weak var playTime: UILabel!
    
    //播放器相关
    var playerItem:AVPlayerItem!
    var player:AVPlayer!
    
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "告白气球", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: filePath!)
        //定义一个playerItem，并监听相关的通知
        playerItem = AVPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        //定义一个视频播放器，通过playerItem径初始化
        player = AVPlayer(playerItem: playerItem)
        //设置大小和位置（全屏）
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44,
                                   width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1920 * 1080)
        //添加到界面上
        self.view.layer.addSublayer(playerLayer)
        
        //设置进度条相关属性
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = false
        
        //播放过程中动态改变进度条值和时间标签
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] cmTime in
            guard let `self` = self, self.player.currentItem?.status == .readyToPlay, self.player.rate != 0 else { return }
            //更新进度条进度值
            let currentTime = CMTimeGetSeconds(self.player.currentTime())
            self.playbackSlider.value = Float(currentTime)
            // 时间显示
            let hour = Int(currentTime / 60)
            let minute = Int(currentTime) % 60
            self.playTime.text = (hour < 10 ? "0\(hour)" : "\(hour)") + ":" + (minute < 10 ? "0\(minute)" : "\(minute)")
            //更新后台播放信息，时间等
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //播放按钮点击
    @IBAction func playButtonTapped(_ sender: Any) {
        //根据rate属性判断当前是否在播放，rate 为 0 表示不再播放
        if player.rate == 0 {
            player.play()
            playButton.setTitle("暂停", for: .normal)
        } else {
            player.pause()
            playButton.setTitle("播放", for: .normal)
        }
    }
    
    //拖动进度条改变值时触发
    @IBAction func playbackSliderValueChanged(_ sender: Any) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        //播放器定位到对应的位置
        player.seek(to: targetTime)
        //如果当前时暂停状态，则自动播放
        if player.rate == 0
        {
            player.play()
            playButton.setTitle("暂停", for: .normal)
        }
    }

    @IBAction func playVolumeSliderValueChanged(_ sender: UISlider) {
        // 调整音量，默认为 1.0
        player.volume = sender.value
    }
    //视频播放完毕响应
    @objc func playerDidFinishPlaying() {
        print("播放完毕!")
    }

}
