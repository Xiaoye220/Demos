//
//  MusicPlayerViewController.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/28.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicPlayerViewController: UIViewController {

    //播放按钮
    @IBOutlet weak var playButton: UIButton!
    
    //可拖动的进度条
    @IBOutlet weak var playbackSlider: UISlider!
    
    //当前播放时间标签
    @IBOutlet weak var playTime: UILabel!
    
    //播放器相关
    var playerItem:AVPlayerItem!
    var player:AVPlayer!
    var  i = 0
    //是否能成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.i = self.i + 1
            print(self.i)
        }
        // 注册后台播放，可以放到 appDelegate 中
        // 使用前 Targets -> Capabilities ->BackgroundModes 设为 ON，同时勾选“Audio, AirPlay, and Picture in Picture”
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        //初始化播放器，url 可以为网络资源
        let filePath = Bundle.main.path(forResource: "July - My Soul", ofType: "mp3")!
        let url = URL(fileURLWithPath: filePath)
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem!)
        
        //设置进度条相关属性
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = false
        
        //播放过程中动态改变进度条值和时间标签
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] cmTime in
            // 网络内容 self.player.currentItem?.status 会出现 unknown
            guard let `self` = self, self.player.currentItem?.status == .readyToPlay, self.player.rate != 0 else { return }
            //更新进度条进度值
            let currentTime = CMTimeGetSeconds(self.player.currentTime())
            self.playbackSlider.value = Float(currentTime)
            // 时间显示
            let hour = Int(currentTime / 60)
            let minute = Int(currentTime) % 60
            self.playTime.text = (hour < 10 ? "0\(hour)" : "\(hour)") + ":" + (minute < 10 ? "0\(minute)" : "\(minute)")
            //更新后台播放信息，时间等
            self.setInfoCenterCredentials(playbackRate: 1)
        }
    }
    
    //页面显示时添加歌曲播放结束通知监听
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        //告诉系统接受远程响应事件，并注册成为第一响应者
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    //页面消失时取消歌曲播放结束通知监听
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        //停止接受远程响应事件
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //播放按钮点击
    @IBAction func playButtonTapped(_ sender: Any) {
        //根据rate属性判断当前是否在播放，rate 为 0 表示不再播放
        if player.rate == 0 {
            player.play()
            playButton.setTitle("暂停", for: .normal)
            //后台播放信息状态为播放
            setInfoCenterCredentials(playbackRate: 1)
        } else {
            player.pause()
            playButton.setTitle("播放", for: .normal)
            //后台播放信息状态为暂停
            setInfoCenterCredentials(playbackRate: 0)
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
    
    //歌曲播放完毕
    @objc func finishedPlaying(myNotification:NSNotification) {
        print("播放完毕!")
        let stopedPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero, completionHandler: nil)
        playButton.setTitle("播放", for: .normal)
    }
    
    
    //响应后台操作
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            print("no event\n")
            return
        }
        
        if event.type == UIEventType.remoteControl {
            switch event.subtype {
            case .remoteControlTogglePlayPause:
                print("暂停/播放")
            case .remoteControlPreviousTrack:
                print("上一首")
            case .remoteControlNextTrack:
                print("下一首")
            case .remoteControlPlay:
                print("播放")
                player.play()
            case .remoteControlPause:
                print("暂停")
                player.pause()
                //后台播放显示信息进度停止
                setInfoCenterCredentials(playbackRate: 0)
            default:
                break
            }
        }
    }
    
    // 设置后台播放显示信息
    func setInfoCenterCredentials(playbackRate: Int) {
        let mpic = MPNowPlayingInfoCenter.default()
        
        //专辑封面
        let mySize = CGSize(width: 400, height: 400)
        let albumArt = MPMediaItemArtwork(boundsSize:mySize) { sz in
            return UIImage(named: "cover")!
        }
        
        //获取进度
        let postion = Double(self.playbackSlider.value)
        let duration = Double(self.playbackSlider.maximumValue)
        
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: "July",
                               MPMediaItemPropertyArtist: "My Soul",
                               MPMediaItemPropertyArtwork: albumArt,
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: postion,
                               MPMediaItemPropertyPlaybackDuration: duration,
                               MPNowPlayingInfoPropertyPlaybackRate: playbackRate]
    }

}
