//
//  ViewController.swift
//  AVFoundationDemo
//
//  Created by YZF on 15/12/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    enum Contents: String {
        case videoRecord_1 = "视频录制"
        case videoRecord_2 = "视频录制(多段视频并合并)"
        case videoRecord_3 = "视频录制(设置拍摄窗口大小)"
        case capturePhoto = "照片拍摄(对焦,前后置摄像头切换)"
        case wxVideoRecord = "微信拍摄"
        case musicPlayer_1 = "音乐播放器(控制中心，锁屏下可显示信息)"
        case musicPlayer_2 = "音乐播放器(边下边播，缓存)"
        case videoPlayer = "视频播放器(音量)"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    let contents: [[Contents]] = [[.videoRecord_1, .videoRecord_2, .videoRecord_3, .capturePhoto, .wxVideoRecord],
                                  [.musicPlayer_1, .musicPlayer_2, .videoPlayer]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var controller: UIViewController!
        switch contents[indexPath.section][indexPath.row] {
        case .videoRecord_1:
            controller = VideoRecordViewController_1()
        case .videoRecord_2:
            controller = VideoRecordViewController_2()
        case .videoRecord_3:
            controller = VideoRecordViewController_3()
        case .capturePhoto:
            controller = CapturePhotoViewController()
        case .wxVideoRecord:
            controller = WeiXinCameraViewController()
        case .musicPlayer_1:
            controller = MusicPlayerViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            return
        case .musicPlayer_2:
            controller = MusicPlayerWithLoaderViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            return
        case .videoPlayer:
            controller = VideoPlayerViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        self.present(controller, animated: true, completion: nil)
    }
    
}

