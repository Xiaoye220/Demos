//
//  BaiduMapViewController_4.swift
//  MapDemo
//
//  Created by YZF on 2018/2/1.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

/// 百度地图(路线)
class BaiduMapViewController_4: UIViewController {

    var routeSearch = BMKRouteSearch()
    
    // 起始终止地输入
    var startTextField: UITextField!
    var endTextField: UITextField!
    // 搜索按钮
    var searchButton: UIButton!
    var mapView: BMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        routeSearch.delegate = self
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        //添加百度地图
        mapView = BMKMapView(frame: CGRect(x: 0, y: topHeight + 80, width: screenWidth, height: screenHeight - (topHeight + 80)))
        // 定位模式，定位跟随模式，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.zoomLevel = 15
        mapView.delegate = self
        //mapView.setCenter(CLLocationManager().location!.coordinate, animated: true)
        
        startTextField = UITextField(frame: CGRect(x: 20, y: topHeight, width: screenWidth - 100, height: 40))
        startTextField.placeholder = "起点地址"
        startTextField.text = "天安门"
        endTextField = UITextField(frame: CGRect(x: 20, y: topHeight + 40, width: screenWidth - 100, height: 40))
        endTextField.placeholder = "终点地址"
        endTextField.text = "北京大学"
        
        searchButton = UIButton(frame: CGRect(x: screenWidth - 80, y: topHeight, width: 80, height: 80))
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1)
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        
        view.addSubview(mapView)
        view.addSubview(startTextField)
        view.addSubview(endTextField)
        view.addSubview(searchButton)
    }
    
    @objc func search(_ sender: UIButton) {
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        // 起点终点
        let start = BMKPlanNode()
        start.name = startTextField.text
        start.cityName = "北京"
        let end = BMKPlanNode()
        end.name = endTextField.text
        end.cityName = "北京"
        // 构造步行查询基础信息类
        let walkingRouteSearchOption = BMKWalkingRoutePlanOption()
        walkingRouteSearchOption.from = start
        walkingRouteSearchOption.to = end
        // 步行查询
        let flag = routeSearch.walkingSearch(walkingRouteSearchOption)
        if flag == false {
            showMessage("route search fail")
        }
    }
    
    // 根据路线调整 mapView 的位置大小
    func mapViewFitPolyLine(_ polyLine: BMKPolyline) {
        var ltX, ltY, rbX, rbY: Double
        if polyLine.pointCount < 1 { return }
        let pt = polyLine.points[0]
        ltX = pt.x
        ltY = pt.y
        rbX = pt.x
        rbY = pt.y
        for i in 0 ..< polyLine.pointCount {
            let pt = polyLine.points[Int(i)]
            if pt.x < ltX { ltX = pt.x }
            if pt.x > rbX { rbX = pt.x }
            if pt.y > ltY { ltY = pt.y }
            if pt.y < rbY { rbY = pt.y }
        }
        let origin = BMKMapPoint(x: ltX, y: ltY)
        let size = BMKMapSize(width: rbX - ltX, height: rbY - ltY)
        let rect = BMKMapRect(origin: origin, size: size)
        // 这里得 animated 为 true 的话是一个异步的操作，false 为同步的。个人测试后的结果，具体准确不准确不确定。
        mapView.setVisibleMapRect(rect, animated: false)
        mapView.zoomLevel = mapView.zoomLevel - 0.3
    }
    

}

extension BaiduMapViewController_4: BMKRouteSearchDelegate {
    func onGetWalkingRouteResult(_ searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            // 获取路线
            if let routes = result.routes as? [BMKWalkingRouteLine], !routes.isEmpty {
                let route = routes[0]
                // 路段所经过的地理坐标集合
                var points: [BMKMapPoint] = []
                var pointCount: Int32 = 0
                // 获取步行路线中的路段
                if let steps = route.steps as? [BMKWalkingStep] {
                    for step in steps {
                        let pointAnnotation =  BMKPointAnnotation()
                        pointAnnotation.title = step.instruction
                        pointAnnotation.coordinate = step.entrace.location
                        mapView.addAnnotation(pointAnnotation)
                        
                        for i in 0 ..< step.pointsCount {
                            points.append(step.points[Int(i)])
                        }
                        pointCount += step.pointsCount
                    }
                }
                // 获取所有点集合后传入数组指针
                let polyLine = BMKPolyline(points: &points, count: UInt(pointCount))
                mapView.add(polyLine)
                mapViewFitPolyLine(polyLine!)
            }
        } else {
            print(error)
        }
    }
}

extension BaiduMapViewController_4: BMKMapViewDelegate {
    // 编辑路线
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if let polylineView = BMKPolylineView(overlay: overlay) {
            //polylineView.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            polylineView.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            polylineView.lineWidth = 3.0
            polylineView.layer.shouldRasterize = true
            polylineView.layer.contentsScale = UIScreen.main.scale
            return polylineView
        }
        return nil
    }
    
}
