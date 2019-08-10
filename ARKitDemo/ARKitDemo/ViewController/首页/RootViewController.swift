//
//  ViewController.swift
//  ARKitDemo
//
//  Created by YZF on 2018/7/21.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Content: String {
        case Default3D = "官方 3D Demo"
        case Default2D = "官方 2D Demo"
        case Demo_1 = "平地添加模型"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    let contents: [[Content]] = [[.Default3D, .Default2D], [.Demo_1]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = contents[indexPath.section][indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        var controller: UIViewController!
        switch content {
        case .Default3D:
            controller = Default3DViewController()
        case .Default2D:
            controller = Default2DViewController()
        case .Demo_1:
            controller = DemoViewController_1()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

