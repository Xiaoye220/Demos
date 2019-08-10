//
//  CoreLocationViewController.swift
//  MapDemo
//
//  Created by YZF on 2018/1/26.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationViewController: UIViewController {

    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    var label: UILabel!
    
    var currentLocation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        label = UILabel(frame: CGRect(x: 0, y: statusHeight + nvHeight, width: screenWidth, height: screenHeight))
        label.numberOfLines = 0
        view.addSubview(label)
        
        setupLocationManager()
        reverseGeocode()
        locationEncode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupLocationManager() {
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }

    ///地理信息反编码，将经纬度转为 具体地址
    func reverseGeocode() {
        let geocoder = CLGeocoder()
        let currentLocation = locationManager.location!
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            //显示所有信息
            if let error = error {
                print("错误：\(error.localizedDescription))")
                return
            }
            
            if let p = placemarks?[0]{
                var address = ""
                
                if let country = p.country {
                    address.append("国家：\(country)\n")
                }
                if let administrativeArea = p.administrativeArea {
                    address.append("省份：\(administrativeArea)\n")
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    address.append("其他行政区域信息（自治区等）：\(subAdministrativeArea)\n")
                }
                if let locality = p.locality {
                    address.append("城市：\(locality)\n")
                }
                if let subLocality = p.subLocality {
                    address.append("区划：\(subLocality)\n")
                }
                if let thoroughfare = p.thoroughfare {
                    address.append("街道：\(thoroughfare)\n")
                }
                if let subThoroughfare = p.subThoroughfare {
                    address.append("门牌：\(subThoroughfare)\n")
                }
                if let name = p.name {
                    address.append("地名：\(name)\n")
                }
                if let isoCountryCode = p.isoCountryCode {
                    address.append("国家编码：\(isoCountryCode)\n")
                }
                if let postalCode = p.postalCode {
                    address.append("邮编：\(postalCode)\n")
                }
                if let areasOfInterest = p.areasOfInterest {
                    address.append("关联的或利益相关的地标：\(areasOfInterest)\n")
                }
                if let ocean = p.ocean {
                    address.append("海洋：\(ocean)\n")
                }
                if let inlandWater = p.inlandWater {
                    address.append("水源，湖泊：\(inlandWater)\n")
                }
                
                print(address)
                
                self.label.text = """
                
                地理信息反编码:
                \(address)
                \(self.label.text ?? "")
                """
            } else {
                print("No placemarks!")
            }
        })
    }
    
    ///地理信息编码，将具体地址转为 经纬度
    func locationEncode(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("福州新大陆科技园", completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            
            if error != nil {
                print("错误：\(error!.localizedDescription))")
                return
            }
            if let p = placemarks?[0] {
                self.label.text = """
                
                地理信息编码:
                经度：\(p.location!.coordinate.longitude)
                纬度：\(p.location!.coordinate.latitude)
                \(self.label.text ?? "")
                """
                print("经度：\(p.location!.coordinate.longitude)   "
                    + "纬度：\(p.location!.coordinate.latitude)")
            } else {
                print("No placemarks!")
            }
        })
    }
}

extension CoreLocationViewController: CLLocationManagerDelegate {
    // 定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // 获取最新的坐标
        let currLocation: CLLocation = locations.last!
        
        // 获取经度
        let longitude = currLocation.coordinate.longitude
        // 获取纬度
        let latitude = currLocation.coordinate.latitude
        // 获取海拔
        let altitude = currLocation.altitude
        // 获取水平精度
        let horizontalAccuracy = currLocation.horizontalAccuracy
        // 获取垂直精度
        let verticalAccuracy = currLocation.verticalAccuracy
        // 获取方向
        let course = currLocation.course
        // 获取速度
        let speed = currLocation.speed
        
        if currentLocation.isEmpty {
            currentLocation = """
            
            当前位置信息：
            经度：\(longitude)
            纬度：\(latitude)
            海拔：\(altitude)
            水平精度：\(horizontalAccuracy)
            垂直精度：\(verticalAccuracy)
            方向：\(course)
            速度：\(speed)
            """
            label.text = currentLocation + (self.label.text ?? "")
        }
    }
}
