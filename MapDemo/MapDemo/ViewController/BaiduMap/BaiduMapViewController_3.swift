//
//  BaiduMapViewController_3.swift
//  MapDemo
//
//  Created by YZF on 2018/1/31.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

/// 百度地图(POI检索)
class BaiduMapViewController_3: UIViewController {
    
    enum SearchOption {
        case city
        case nearBy
    }

    // 输入框
    var textField: UITextField!
    // 搜索按钮
    var searchButton: UIButton!
    var mapView: BMKMapView!
    var pointAnnotations: [BMKPointAnnotation] = []
    
    //初始化搜索对象
    var poiSearcher = BMKPoiSearch()
    //请求参数类 BMKCitySearchOption，城市搜索
    var citySearchOption = BMKCitySearchOption()
    // 附近搜索
    var nearBySearchOption = BMKNearbySearchOption()
    
    // 附近搜索，要同城搜索的话需要改成 .city
    let searchOption: SearchOption = .nearBy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupView()
        setupPOISearcher()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView() {
        //添加百度地图
        mapView = BMKMapView(frame: CGRect(x: 0, y: topHeight + 40, width: screenWidth, height: screenHeight - (topHeight + 40)))
        // 定位模式，定位跟随模式，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.zoomLevel = 15
        if searchOption == .nearBy {
            mapView.setCenter(CLLocationManager().location!.coordinate, animated: true)
        }
        
        textField = UITextField(frame: CGRect(x: 20, y: topHeight, width: screenWidth - 100, height: 40))
        textField.placeholder = "输入地址"
        
        searchButton = UIButton(frame: CGRect(x: screenWidth - 80, y: topHeight, width: 80, height: 40))
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1)
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        
        view.addSubview(mapView)
        view.addSubview(textField)
        view.addSubview(searchButton)
    }
    
    func setupPOISearcher() {
        poiSearcher.delegate = self
        
        // 设置 search 参数，一页10条，第0页，city不选默认全国
        citySearchOption.pageIndex = 0
        citySearchOption.pageCapacity = 10
        citySearchOption.city = "北京"
        
        // 区域搜索参数
        nearBySearchOption.pageIndex = 0
        nearBySearchOption.pageCapacity = 10
        nearBySearchOption.location = CLLocationManager().location!.coordinate
        nearBySearchOption.radius = 2000
    }
    
    @objc func search(_ sender: UIButton) {
        textField.resignFirstResponder()
        // 搜索关键词
        citySearchOption.keyword = textField.text
        nearBySearchOption.keyword = textField.text
        // 开始检索
        let flag: Bool
        switch searchOption {
        case .city:
            flag = poiSearcher.poiSearch(inCity: citySearchOption)
        case .nearBy:
            flag = poiSearcher.poiSearchNear(by: nearBySearchOption)
        }
        //let flag = poiSearcher.poiSearch(inCity: citySearchOption)
        //let flag = poiSearcher.poiSearchNear(by: nearBySearchOption)
        if flag == false {
            showMessage("检索发送失败")
        }
    }
    
    func addPointAnnotations() {
        for pointAnnotation in pointAnnotations {
            mapView.addAnnotation(pointAnnotation)
        }
    }
}

extension BaiduMapViewController_3: BMKPoiSearchDelegate {
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        // 检索结果正常返回
        if errorCode == BMK_SEARCH_NO_ERROR {
            if let poiInfos = poiResult.poiInfoList as? [BMKPoiInfo] {
                pointAnnotations.removeAll()
                for poiInfo in poiInfos {
                    let pointAnnotation =  BMKPointAnnotation()
                    pointAnnotation.title = poiInfo.name
                    pointAnnotation.coordinate = poiInfo.pt
                    pointAnnotations.append(pointAnnotation)
                }
                addPointAnnotations()
            }
        } else {
            print(errorCode)
        }
    }
}
