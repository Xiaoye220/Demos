//
//  MapKitViewController_3.swift
//  MapDemo
//
//  Created by YZF on 2018/2/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import MapKit

/// MapKit(绘制路线)
class MapKitViewController_3: UIViewController {

    // 一个 geocoder 只能用一次，每次使用需要创建一个新的 CLGeocoder
    var geocoder: CLGeocoder {
        return CLGeocoder()
    }
    
    let locationManager = CLLocationManager()

    // 起点和终点
    var start: CLPlacemark?
    var end: CLPlacemark?
    
    // 终点输入
    var textField: UITextField!
    // 搜索按钮
    var searchButton: UIButton!
    var mapView: MKMapView!
    
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
        // 创建 MapView
        mapView = MKMapView(frame: CGRect.init(x: 0, y: topHeight + 40, width: screenWidth, height: screenHeight - (topHeight + 40)))
        mapView.zoomLevel = 15
        mapView.setCenter(locationManager.location!.coordinate, animated: false)
        mapView.delegate = self
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = locationManager.location!.coordinate
        pointAnnotation.title = "我的位置"
        mapView.addAnnotation(pointAnnotation)
        
        textField = UITextField(frame: CGRect(x: 20, y: topHeight, width: screenWidth - 100, height: 40))
        textField.placeholder = "输入目的地"
        
        searchButton = UIButton(frame: CGRect(x: screenWidth - 80, y: topHeight, width: 80, height: 40))
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1)
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        
        view.addSubview(mapView)
        view.addSubview(textField)
        view.addSubview(searchButton)
    }
    
    @objc func search(_ sender: UIButton) {
        textField.resignFirstResponder()
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
            // 起点终点的 Placemark 获取完成后获取路线
            self.getRouteResult()
        }
    }
    
    /// 获取路线信息
    func getRouteResult() {
        guard let start = start, let end = end else { return }
        print("起点:\(start)\n终点:\(end)")
        //self.showMessage("起点:\(start.name ?? "无")\n终点:\(end.name ?? "无")")
        // 创建请求导航路线数据信息
        let request: MKDirectionsRequest = MKDirectionsRequest()
        // 设置起点
        let source = MKPlacemark(placemark: start)
        request.source = MKMapItem(placemark: source)
        // 设置终点
        let destination = MKPlacemark(placemark: end)
        request.destination = MKMapItem(placemark: destination)
        // 出行方式
        request.transportType = .walking
        // 创建导航对象，根据请求，获取实际路线信息
        let directions = MKDirections(request: request)
        
        // 请求路线信息
        directions.calculate { (response, error) in
            guard let response = response else { return }
            // 获取路线
            print("路线条数:\(response.routes.count)")
            for route in response.routes {
                // 添加路线
                self.mapView.add(route.polyline)
                // 每一条路线对应很多 step，如 直走100米，左转直走100米 等
                for step in route.steps {
                    print("\(step.instructions) \(step.distance) 米")
                }
            }
        }
    }
}

extension MapKitViewController_3: MKMapViewDelegate {
    // 详细设置路线
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        polyline.lineWidth = 3
        polyline.strokeColor = .blue
        return polyline
    }
}
