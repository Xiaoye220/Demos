//
//  MapKitViewController_4.swift
//  MapDemo
//
//  Created by YZF on 2018/2/6.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import MapKit


class MapKitViewController_4: UIViewController {

    var mapView: MKMapView!
    
    //定位管理器
    let locationManager: CLLocationManager = CLLocationManager()
    // 终点输入
    var textField: UITextField!
    // 搜索按钮
    var searchButton: UIButton!
    
    var pointAnnotations: [MKPointAnnotation] = []
    
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
        poi()
    }
    
    func poi() {
        // 创建一个POI请求
        let request: MKLocalSearchRequest = MKLocalSearchRequest()
        // 设置请求检索的关键字
        request.naturalLanguageQuery = textField.text
        // 设置请求检索的区域范围
        request.region = mapView.region
        // 根据请求创建检索对象
        let search: MKLocalSearch = MKLocalSearch(request: request)
        // 检索对象
        search.start { (response, error) in
            if let error = error { self.showMessage("poi失败:\(error.localizedDescription)") }
            // 响应对象MKLocalSearchResponse,里面存储着检索出来的"地图项",每个地图项中有包含位置信息, 商家信息等
            if let items = response?.mapItems {
                self.mapView.removeAnnotations(self.pointAnnotations)
                for item in items {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = item.placemark.coordinate
                    pointAnnotation.title = item.name
                    self.mapView.addAnnotation(pointAnnotation)
                    self.pointAnnotations.append(pointAnnotation)
                }
            }
        }
    }
    
}

extension MapKitViewController_4: MKMapViewDelegate {
    
}
