//
//  MapKitViewController_2.swift
//  MapDemo
//
//  Created by YZF on 2018/2/2.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import MapKit

/// MapKit(导航)，默认已经开了定位权限
class MapKitViewController_2: UIViewController {

    // 一个 geocoder 只能用一次，每次使用需要创建一个新的 CLGeocoder
    var geocoder: CLGeocoder {
        return CLGeocoder()
    }

    // 起点和终点
    var start: CLPlacemark?
    var end: CLPlacemark?

    var locationManager = CLLocationManager()
    
    var textField: UITextField!
    var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        textField = UITextField(frame: CGRect(x: 20, y: topHeight, width: screenWidth - 100, height: 40))
        textField.placeholder = "输入目的地"
        
        searchButton = UIButton(frame: CGRect(x: screenWidth - 80, y: topHeight, width: 80, height: 40))
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1)
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(searchButton)
    }
    
    @objc func search(_ sender: UIButton) {
        getPlacemark()
    }
    
    func getPlacemark() {
        let currentLocation = locationManager.location!
        // 通过 DispatchGroup 确保异步获取 起点终点的 Placemark
        let group = DispatchGroup()
        group.enter()
        geocoder.geocodeAddressString(textField.text ?? "沙县小吃", completionHandler: { (placemarks, error) in
            if let error = error { self.showMessage("终点geocode错误：\(error.localizedDescription)") }
            if let p = placemarks, p.count > 0  { self.end = p[0] }
            group.leave()
        })
        group.enter()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error { self.showMessage("起点geocode错误：\(error.localizedDescription)") }
            if let p = placemarks, p.count > 0 { self.start = p[0] }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            // 起点终点的 Placemark 获取完成后跳到 地图app 进行导航
            self.beginNavigation()
        }
    }
    
    func beginNavigation() {
        guard let start = start, let end = end else { return }
        
        // 设置导航地图启动项参数字典
        let dic: [String : Any] = [
            // 导航模式: 步行
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            // 地图样式：标准样式
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            // 显示交通：显示
            MKLaunchOptionsShowsTrafficKey: true
        ]
        
        let startItem = MKMapItem(placemark: MKPlacemark(placemark: start))
        let endItem = MKMapItem(placemark: MKPlacemark(placemark: end))
        // 根据 MKMapItem 的起点和终点组成数组, 通过导航地图启动项参数字典, 调用系统的地图APP进行导航
        MKMapItem.openMaps(with: [startItem, endItem], launchOptions: dic)
    }
}
