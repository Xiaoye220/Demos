//
//  ViewController.swift
//  TextKitDemo
//
//  Created by YZF on 2018/6/29.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Content: String {
        case Configuration = "Configuration"
        case Highlight = "Highlight"
        case Layout = "Layout"
        case Label = "Custom Label"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let contents:[[Content]] = [[.Configuration, .Highlight, .Layout], [.Label]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        if(cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = contents[indexPath.section][indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        var controller: UIViewController
        switch content {
        case .Configuration:
            controller = ConfigurationViewController()
        case .Highlight:
            controller = HighlightViewController()
        case .Layout:
            controller = LayoutViewController()
        case .Label:
            controller = CustomLabelViewController()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

