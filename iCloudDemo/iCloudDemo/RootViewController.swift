//
//  RootViewController.swift
//  iCloudDemo
//
//  Created by YZF on 2019/1/3.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import CloudKit

class RootViewController: BaseViewController {

    enum Content: String, CaseIterable {
        case publicDatabase = "Public Database"
        case privateDatabase = "Private Database"
        case subscription = "Subscribing to Record Changes"
        case sharedDatabase = "Shared Database"
        case fetchChanges = "Fetch Changes"
    }
    
    
    let contents: [[Content]] = [[.publicDatabase, .privateDatabase],
                                 [.sharedDatabase], [.subscription],
                                 [.fetchChanges]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: UITableViewDataSource & UITableViewDelegate
extension RootViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.selectionStyle = .none
        
        cell.textLabel?.text = contents[indexPath.section][indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: BaseViewController? = nil
        switch contents[indexPath.section][indexPath.row] {
        case .publicDatabase:
            let controller = SimpleViewController()
            controller.currentDB = CKContainer.default().publicCloudDatabase
            navigationController?.pushViewController(controller, animated: true)
            
        case .privateDatabase:
            let controller = SimpleViewController()
            controller.currentDB = CKContainer.default().privateCloudDatabase
            navigationController?.pushViewController(controller, animated: true)
            
        case .subscription:
            controller = SubscriptionViewController()
            
        case .sharedDatabase:
            controller = SharedDBViewController()

        case .fetchChanges:
            controller = FetchChangesViewController()
        }
        
        if controller != nil {
            navigationController?.pushViewController(controller!, animated: true)
        }
    }
}
