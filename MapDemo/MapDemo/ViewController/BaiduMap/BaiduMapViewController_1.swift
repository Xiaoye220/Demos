//
//  BaiduMapViewController_1.swift
//  MapDemo
//
//  Created by YZF on 2018/1/30.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import CoreLocation

class BaiduMapViewController_1: UIViewController {

    // 百度api，用户的访问密钥，需要自己去申请
    let ak = "HTmgkKY7cXbNDuuirf1XBuG9jXFdBFe8"
    // 百度api，安全码，iOS 的为 Bundle Identifier
    let mcode = "com.yzf.MapDemo"
    
    //定位管理器
    let locationManager: CLLocationManager = CLLocationManager()
    
    //记录经纬度
    var longitude: CLLocationDegrees!
    var latitude: CLLocationDegrees!
    
    var label: UILabel!
    var imageView: UIImageView!
    var slider: UISlider!
    var zoomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupView()
        
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        label = UILabel.init(frame: CGRect.init(x: 20, y: 100, width: screenWidth, height: 50))
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 200, width: screenWidth, height: 200))
        slider = UISlider.init(frame: CGRect.init(x: 20, y: 450, width: 200, height: 50))
        zoomLabel = UILabel.init(frame: CGRect.init(x: screenWidth - 120, y: 450, width: 100, height: 50))
        
        label.numberOfLines = 0
        slider.addTarget(self, action: #selector(sliderDidchange(sender:)), for: .valueChanged)
        slider.maximumValue = 19
        slider.minimumValue = 3
        slider.isContinuous = false
        slider.value = 11
        zoomLabel.numberOfLines = 0
        
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(slider)
        view.addSubview(zoomLabel)
    }

    //滑块值改变
    @objc func sliderDidchange(sender: AnyObject) {
        //显示地图
        showBaiduMap()
    }
    
    //加载地图
    func showBaiduMap() {
        //地图图片宽度,取值范围：(0, 1024]。
        let width = min(1024, imageView.frame.width * UIScreen.main.scale)
        //地图图片高度,取值范围：(0, 1024]。
        let height = min(1024, imageView.frame.height * UIScreen.main.scale)
        //地图缩放级别,取值范围：[3, 19]。
        let zoom = Int(slider.value)
        zoomLabel.text = "地图级别：\(Int(slider.value))"
        
        //定义NSURL对象
        let url = URL(string: "http://api.map.baidu.com/staticimage/v2?" +
            "ak=\(ak)&mcode=\(mcode)" +
            "&center=\(longitude),\(latitude)&width=\(width)&height=\(height)&zoom=\(zoom)")
        //从网络获取数据流
        do {
            let data = try Data(contentsOf: url!)
            let newImage = UIImage(data: data)
            //通过数据流初始化图片
            self.imageView.image = newImage
        } catch  {
            print("请求失败")
        }
    }
}

extension BaiduMapViewController_1: CLLocationManagerDelegate {
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        //获取经纬度
        longitude = currLocation.coordinate.longitude
        latitude = currLocation.coordinate.latitude
        //显示经纬度
        label.text = "经度：\(longitude!)\n纬度：\(latitude!)"
        
        //显示地图
        showBaiduMap()
    }
}
