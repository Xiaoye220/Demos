//
//  ViewController.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/5.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    enum Content: String {
        case drawViewContents = "Using Metal to Draw a View’s Contents"
    }
    
    var tableView: UITableView!
    
    var contents: [Content] = [.drawViewContents]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableViewFrame = CGRect(x: 0, y: statusBarHeight + 44, width: screenWidth, height: screenHeight - statusBarHeight - 44)
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }


}


extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = contents[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.row]
        switch content {
        case .drawViewContents:
            let controller = DVCViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
