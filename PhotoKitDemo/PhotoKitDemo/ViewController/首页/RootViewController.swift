//
//  ViewController.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/22.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    enum Content: String {
        case getPhoto = "获取所有图片（缩略图）"
        case getCollection = "获取相簿"
        case savePhoto = "保存图片至相册"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var contents: [[Content]] = [[.getPhoto, .getCollection, .savePhoto]]
    
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
        cell.textLabel?.text = contents[indexPath.section][indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        var controller: UIViewController
        switch content {
        case .getPhoto:
            controller = GetPhotoViewController()
        case .getCollection:
            controller = GetCollectionViewController()
        case .savePhoto:
            controller = SavePhotoViewController()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

