//
//  MapKitViewController.swift
//  MapDemo
//
//  Created by YZF on 2018/1/25.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapKitViewController_1: UIViewController {

    var mapView: MKMapView!
        
    //定位管理器
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        createMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMap() {
        // 当前位置权限状态
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse:
            break
        default:
            // 请求权限
            locationManager.requestWhenInUseAuthorization()
            // 位置访问权限改变可以在 delegate 处理
            locationManager.delegate = self
            return
        }
        
        // 创建 MapView
        self.mapView = MKMapView(frame: CGRect.init(x: 0, y: statusHeight + nvHeight, width: screenWidth, height: screenHeight - (statusHeight + nvHeight)))
        self.view.addSubview(self.mapView)
        
        // 地图类型设置 - 标准地图
        self.mapView.mapType = MKMapType.standard
        // 缩放的时候是否显示比例尺
        self.mapView.showsScale = true
        // 是否显示罗盘
        self.mapView.showsCompass = true
        self.mapView.delegate = self
        
        // 创建一个MKCoordinateSpan对象
        // 经纬度的跨度，0 - 2pi 之间，越小跨度越小，地图精度越高
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        
        //定义地图区域和中心坐标
        //使用当前位置
        let center: CLLocation = locationManager.location!
        //使用自定义位置
        //let center: CLLocation = CLLocation(latitude:  32.029171, longitude:  118.788231)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center:  center.coordinate, span:  currentLocationSpan)
        
        //设置显示区域
        self.mapView.setRegion(currentRegion, animated:  true)
        //self.mainMapView.zoomLevel = 11
        //创建一个大头针对象
        let pointAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        pointAnnotation.coordinate = center.coordinate
        //设置点击大头针之后显示的标题
        pointAnnotation.title = "我的位置"
        //设置点击大头针之后显示的描述
        pointAnnotation.subtitle = "在这里"
        //添加大头针
        self.mapView.addAnnotation(pointAnnotation)
    }

}

extension MapKitViewController_1: CLLocationManagerDelegate {
    // 位置访问 AuthorizationStatus 改变
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            createMap()
        }
    }
}

extension MapKitViewController_1: MKMapViewDelegate {
    // 自定义大头针 View，可以复用
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKPinAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        } else {
            annotationView.annotation = annotation
        }
        annotationView.pinTintColor = #colorLiteral(red: 0.7277297378, green: 0.1776980162, blue: 0.6334885955, alpha: 1)
        annotationView.canShowCallout = true
        annotationView.animatesDrop = true
        
        return annotationView
    }
    
    // 常用 delegate
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // 地图缩放级别发送改变时
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 地图缩放完毕触法
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        // 开始加载地图
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // 地图加载结束
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        // 地图加载失败
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        // 正在跟踪用户的位置
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        // 停止跟踪用户的位置
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // 更新用户的位置
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        // 跟踪用户的位置失败
    }
    
    
    
}
