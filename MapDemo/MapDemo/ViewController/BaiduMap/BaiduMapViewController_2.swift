//
//  BaiduMapViewController_2.swift
//  MapDemo
//
//  Created by YZF on 2018/1/31.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

/// 百度地图(定位)
class BaiduMapViewController_2: UIViewController {
    // 定位管理器
    let cllocationManager: CLLocationManager = CLLocationManager()
    
    //定位管理器
    let locationManager: BMKLocationService = BMKLocationService()
    
    //百度地图View
    var mapView: BMKMapView!
    var pointAnnotation: BMKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupView()
        // 如果已获取定位权限，执行代码
        doWithAuthorizedWhenInUse {
            // 开始持续定位
            locationManager.delegate = self
            locationManager.startUserLocationService()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        //添加百度地图，并全屏显示
        mapView = BMKMapView(frame: CGRect(x: 0, y: statusHeight + nvHeight, width: screenWidth, height: screenHeight - (statusHeight + nvHeight)))
        view.addSubview(mapView!)
        
        // 定位模式，定位跟随模式，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.zoomLevel = 18
        mapView.delegate = self
            
        // 添加一个标记点(PointAnnotation）
        pointAnnotation =  BMKPointAnnotation()
        pointAnnotation.title = "我的位置"
        mapView.addAnnotation(pointAnnotation)
    }
    
    func updateLocation(_ userLocation: BMKUserLocation) {
        //地图中心点坐标
        let center = userLocation.location.coordinate
//        //设置地图的显示范围（越小越精确）
//        let span = BMKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        //设置地图最终显示区域
//        let region = BMKCoordinateRegion(center: center, span: span)
//        mapView.region = region
        
        mapView.setCenter(center, animated: true)
        pointAnnotation.coordinate = center
    }
    
    func doWithAuthorizedWhenInUse(_ handle: () -> Void) {
        // 当前位置权限状态
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse:
            handle()
        default:
            // 请求权限
            cllocationManager.requestWhenInUseAuthorization()
            // 位置访问权限改变可以在 delegate 处理
            cllocationManager.delegate = self
        }
    }

}

extension BaiduMapViewController_2: BMKMapViewDelegate {
    
}

extension BaiduMapViewController_2: BMKLocationServiceDelegate {
    // 位置更新
    func didUpdate(_ userLocation: BMKUserLocation!) {
        print("latitude: \(userLocation.location.coordinate.latitude), longitude: \(userLocation.location.coordinate.longitude)")
        updateLocation(userLocation)
    }
}

extension BaiduMapViewController_2: CLLocationManagerDelegate {
    // 权限请求，权限改变
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUserLocationService()
        }
    }
}

