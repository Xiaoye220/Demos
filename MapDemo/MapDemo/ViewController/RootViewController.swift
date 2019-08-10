//
//  ViewController.swift
//  MapDemo
//
//  Created by YZF on 2018/1/25.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    enum Content: String {
        case coreLocation = "CoreLocation(定位、地理信息编码)"
        case mapKit_1 = "MapKit(定位、基本地图)"
        case mapKit_2 = "MapKit(打开地图APP进行导航)"
        case mapKit_3 = "MapKit(绘制路线)"
        case mapKit_4 = "MapKit(POI检索)"
        case baiduMap_1 = "百度地图(静态地图api)"
        case baiduMap_2 = "百度地图(定位)"
        case baiduMap_3 = "百度地图(POI检索)"
        case baiduMap_4 = "百度地图(绘制路线)"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var contents: [[Content]] = [[.coreLocation], [.mapKit_1, .mapKit_2, .mapKit_3, .mapKit_4], [.baiduMap_2, .baiduMap_3, .baiduMap_4]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        let content = contents[indexPath.section][indexPath.row]
        cell.textLabel?.text = content.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        var controller: UIViewController
        switch content {
        case .coreLocation:
            controller = CoreLocationViewController()
        case .mapKit_1:
            controller = MapKitViewController_1()
        case .mapKit_2:
            controller = MapKitViewController_2()
        case .mapKit_3:
            controller = MapKitViewController_3()
        case .mapKit_4:
            controller = MapKitViewController_4()
        case .baiduMap_1:
            controller = BaiduMapViewController_1()
        case .baiduMap_2:
            controller = BaiduMapViewController_2()
        case .baiduMap_3:
            controller = BaiduMapViewController_3()
        case .baiduMap_4:
            controller = BaiduMapViewController_4()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

