//
//  ViewController.swift
//  Coregraph_1icsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Content: String {
        case line_1 = "画线（直线，虚线，带样式）"
        case line_2 = "画线（圆弧，矩形）"
        case line_3 = "画线（贝塞尔曲线）"
        case graph_1 = "画图形（颜色填充）"
        case graph_2 = "画图形（多条子路径绘制复杂图形）"
        case image = "绘制 image"
        case text = "绘制 text"
        case animation_1 = "带动画绘制（自定义动画路径）"
        case animation_2 = "带动画绘制（线条动态绘制）"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let contents: [[Content]] = [[.line_1, .line_2, .line_3], [.graph_1, .graph_2], [.image, .text], [.animation_1, .animation_2]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
        let controller = DrawViewController()
        let view: UIView
        
        switch content {
        case .line_1:
            view = DrawLineView_1()
        case .line_2:
            view = DrawLineView_2()
        case .line_3:
            view = DrawLineView_3()
        case .graph_1:
            view = DrawGraphView_1()
        case .graph_2:
            view = DrawGraphView_2()
        case .image:
            view = DrawImageView()
        case .text:
            view = DrawTextView()
        case .animation_1:
            view = DrawWithAnimation_1()
        case .animation_2:
            view = DrawWithAnimation_2()
        }
        
        controller.drawView = view
        navigationController?.pushViewController(controller, animated: true)
    }
}

