//
//  MusicPlayerWithLoaderViewController.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/29.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

var playerItemStatusContext = 0
var loadedTimeRangesContext = 0
var rateContext = 0
var currentItemContext = 0

class MusicPlayerWithLoaderViewController: UIViewController {
    
    //播放按钮
    @IBOutlet weak var playButton: UIButton!
    
    //可拖动的进度条
    @IBOutlet weak var playbackSlider: UISlider!
    
    //当前播放时间标签
    @IBOutlet weak var playTime: UILabel!
    
    //播放器相关
    var asset: AVURLAsset!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    
    // player PeriodicTimeObserver
    var timeObserverToken: Any?
    
    var loadingRequests: [AVAssetResourceLoadingRequest] = []
    
    // url 不能是 http 和 https 作为 scheme，需要自定义一个，否则不回调 AVAssetResourceLoaderDelegate 的方法。requestTask 请求数据的时候再换成 http、https 下载
    let url = URL(string: "scheme://raw.githubusercontent.com/Xiaoye220/Demos/master/AVFoundationDemo/AVFoundationDemo/July%20-%20My%20Soul.mp3")!

    let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("temp.mp3").path
    
    var fileLength: Int64 = 0
    var cacheLength: Int64 = 0
    
    // 通过 URLSession 请求数据时需要用到的一些变量
    var request: URLRequest!
    var requestTask: URLSessionDataTask!
    var requestTaskOffset: Int64 = 0
    
    var duration: String = "00:00"
    
    // 是否有 seek 操作
    var isSeek = false
    
    //是否能成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playButton.backgroundColor = .gray
        self.playButton.isEnabled = false
        
        print(cachePath)
        
        setAsset()
    }
    
    //页面消失时取消歌曲播放结束通知监听
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        if self.playerItem != nil {
            self.playerItem.removeObserver(self, forKeyPath: "status")
            self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        }
        if self.player != nil {
            self.player.removeObserver(self, forKeyPath: "rate")
            self.player.removeObserver(self, forKeyPath: "currentItem")
        }
        if let token = timeObserverToken {
            self.player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 创建 asset
    func setAsset() {
        self.asset = AVURLAsset(url: url)
        self.asset.resourceLoader.setDelegate(self, queue: DispatchQueue.global())
        // 调用 loadValuesAsynchronously 方法，当获取到 asset 的 playable 以及 duration 属性的值时回调 completionHandler 处理
        // 常用的属性有 tracks，duration，playable
        self.asset.loadValuesAsynchronously(forKeys: ["playable", "duration"]) { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                var error: NSError? = nil
                // 获取属性 playable 的状态，为 loaded 表示 load 成功
                let playableStatus = self.asset.statusOfValue(forKey: "playable", error: &error)
                switch playableStatus {
                case .loaded:
                    // asset load 成功后 创建 playerItem，player
                    print("playable loaded/n")
                    self.prepareToPlayAsset()
                default:
                    break
                }
                let durationStatus = self.asset.statusOfValue(forKey: "duration", error: &error)
                switch durationStatus {
                case .loaded:
                    // duration 获取成功后设置进度条
                    print("duration loaded/n")
                    self.setPlaybackSlider()
                default:
                    break
                }
            }
        }
    }
    
    // 创建 playerItem，player
    func prepareToPlayAsset() {
        self.playerItem = AVPlayerItem(asset: asset)
        // KVO 监听 playerItem 的 status，loadedTimeRanges 属性。以及监听 playerItem 播放完成。
        self.playerItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: &playerItemStatusContext)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new, .initial], context: &loadedTimeRangesContext)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // KVO 监听 player 的 rate，currentItem 属性
        self.player = AVPlayer(playerItem: self.playerItem)
        // automaticallyWaitsToMinimizeStalling 使用 HLS 默认为 true，会要求有足够缓存才会播放，不会立刻播放
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.addObserver(self, forKeyPath: "rate", options: [.new, .initial], context: &rateContext)
        self.player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial], context: &currentItemContext)
    }
    
    // 设置进度条
    func setPlaybackSlider() {
        //设置进度条相关属性
        let duration : CMTime = self.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = false
        
        let hour = Int(seconds / 60)
        let minute = Int(seconds) % 60
        self.duration = (hour < 10 ? "0\(hour)" : "\(hour)") + ":" + (minute < 10 ? "0\(minute)" : "\(minute)")
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
        isSeek = true
        //播放器定位到对应的位置
        player.seek(to: targetTime)
        //如果当前时暂停状态，则自动播放
        player.play()
        playButton.setTitle("暂停", for: .normal)
    }
    
}

/// 监听处理
extension MusicPlayerWithLoaderViewController {
    //歌曲播放完毕
    @objc func finishedPlaying(myNotification: NSNotification) {
        print("播放完毕!")
        let stopedPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero, completionHandler: nil)
        playButton.setTitle("播放", for: .normal)
    }
    
    // KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &playerItemStatusContext {
            if let rawValue = change?[.newKey] as? Int, let status = AVPlayerItemStatus(rawValue: rawValue)  {
                //print("status:\(status.rawValue)")
                switch status {
                case .readyToPlay:
                    print("playeritem readyToPlay\n")
                    self.playButton.backgroundColor = #colorLiteral(red: 0, green: 0.6933178306, blue: 0.7985185981, alpha: 1)
                    self.playButton.isEnabled = true
                    //播放过程中动态改变进度条值和时间标签
                    self.timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] _ in
                        guard let `self` = self else { return }
                        //更新进度条进度值
                        let currentTime = CMTimeGetSeconds(self.player.currentTime())
                        self.playbackSlider.value = Float(currentTime)
                        // 时间显示
                        let hour = Int(currentTime / 60)
                        let minute = Int(currentTime) % 60
                        self.playTime.text = (hour < 10 ? "0\(hour)" : "\(hour)") + ":" + (minute < 10 ? "0\(minute)" : "\(minute)") + "/" + self.duration
                    }
                default:
                    break
                }
            }
        } else if context == &loadedTimeRangesContext {
            if let loadedTimeRanges = change?[.newKey] as? [NSValue], !loadedTimeRanges.isEmpty {
                let timeRange = loadedTimeRanges.first!.timeRangeValue
                let time = CMTimeAdd(timeRange.start, timeRange.duration)
                let _ = CMTimeGetSeconds(time)
                //print("loadedTime:\(Int(seconds))")
            }
        } else if context == &rateContext {
            if let _ = change?[.newKey] as? Float {
                //print("rate:\(rate)")
            }
        } else if context == &currentItemContext {
            print("player added playerItem: \(self.player.currentItem != nil)")

        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}


extension MusicPlayerWithLoaderViewController: AVAssetResourceLoaderDelegate {
    
    // 当有 loadingRequest 的时候调用该方法，一次下载会多次调用该方法
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        // 当 requestTask 为 nil 时说明未创建下载任务，创建下载任务
        if requestTask == nil {
            // 将 url 的自定义 scheme 换成 https 请求数据
            let resourceURL = loadingRequest.request.url!
            var components = URLComponents(url: resourceURL, resolvingAgainstBaseURL: false)!
            components.scheme = "https"
            let requestURL = components.url!
            
            request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
            //如果支持断点续传，可以从当中某个位置下载
            //request.addValue("bytes=\(loadingRequest.dataRequest!.requestedOffset)-\(self.fileLength - 1)", forHTTPHeaderField: "Range")
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
            self.requestTask = urlSession.dataTask(with: request)
            self.requestTask.resume()
        } else {
            // seek 后重新下载数据
            if isSeek {
                self.requestTask.cancel()
                
                // 删除原有缓存文件
                do {
                    try FileManager.default.removeItem(atPath: cachePath)
                } catch {}
                
                self.cacheLength = 0
                // 设置 seek 后重新下载的起始位置
                self.requestTaskOffset = loadingRequest.dataRequest!.requestedOffset

                //如果服务端支持断点续传，可以从当中某个位置下载
                request.addValue("bytes=\(requestTaskOffset)-\(self.fileLength - 1)", forHTTPHeaderField: "Range")
                
                let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
                self.requestTask = urlSession.dataTask(with: request)
                self.requestTask.resume()
                isSeek = false
            } else {
                // 不用创建 requestTask 则直接将下载的 data 返回
                processRequestList()
            }
        }
        //print("shouldWaitForLoadingOfRequestedResource")
        self.loadingRequests.append(loadingRequest)
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        //print("resourceLoader didCancel")
        if let index = self.loadingRequests.index(of: loadingRequest) {
            self.loadingRequests.remove(at: index)
        }
    }
}


extension MusicPlayerWithLoaderViewController: URLSessionDataDelegate {
    // 收到服务器 response
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print(response)
        completionHandler(.allow)
        // 获取 fileLength
        self.fileLength = response.expectedContentLength
    }
    
    // 接收的数据，写入到本地文件中，当做缓存。然后接着读取本地文件 data 进行播放
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //print("urlSession didReceiveData: \(data)")
        if !FileManager.default.fileExists(atPath: cachePath) {
            FileManager.default.createFile(atPath: cachePath, contents: nil, attributes: nil)
        }
        // 写入 data 到缓存文件中
        do {
            let handle = try FileHandle(forWritingTo: URL(string: cachePath)!)
            handle.seek(toFileOffset: UInt64(cacheLength))//.seekToEndOfFile()
            handle.write(data)
        } catch {
            print("数据写入失败")
        }
        
        // 缓存数据长度
        self.cacheLength += Int64(data.count)
        processRequestList()
    }
    
    // 请求完成
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("urlSession didCompleteWithError:\(String(describing: error ?? nil))")
    }
   
    // 将下载好的 data 作为 loadingRequests 的 response 返回
    func processRequestList() {
        for request in loadingRequests {
            if finishLoadingData(request) {
                if let index = self.loadingRequests.index(of: request) {
                    self.loadingRequests.remove(at: index)
                }
            }
        }
    }
    
    // 从已经缓存的数据中取出指定位置的 data 填充 loadingRequest 的 response，则 player 通过 response 播放音频
    func finishLoadingData(_ loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        if let cir = loadingRequest.contentInformationRequest {
            cir.contentType = "audio/mpeg"
            cir.isByteRangeAccessSupported = true
            cir.contentLength = self.fileLength
        }
        
        let dataRequest = loadingRequest.dataRequest!
        
        let requestedLength = dataRequest.requestedLength
        let requestedOffset = dataRequest.requestedOffset
        let currentOffset = dataRequest.currentOffset
        
        print("requestedOffset: \(requestedOffset/1024)\ncurrentOffset: \(currentOffset/1024)\nrequestedLength: \(requestedLength/1024)\ncacheLength: \(cacheLength/1024)\n")
        
        let respondLength = min(max(0, Int(cacheLength - Int64(currentOffset - requestTaskOffset))), requestedLength)
        
        // 从缓存数据中读取数据作为 loadingRequest 的 response
        let handle = FileHandle.init(forReadingAtPath: cachePath)!
        handle.seek(toFileOffset: UInt64(currentOffset - requestTaskOffset))
        let cacheData = handle.readData(ofLength: respondLength)
        
        // respond 后，currentOffset 增加相应 data.length
        loadingRequest.dataRequest?.respond(with: cacheData)
        
        if cacheLength >= requestedLength {
            loadingRequest.finishLoading()
            //print("finishLoading")
            return true
        }
        return false
    }
}
