//
//  BaseViewController.swift
//  iCloudDemo
//
//  Created by YZF on 2019/1/3.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import MBProgressHUD
import CloudKit

class BaseViewController: UIViewController {

    lazy var hud: MBProgressHUD = {
        let hud = MBProgressHUD.init(view: view)
        view.addSubview(hud)
        return hud
    }()
    
    var tableView: UITableView!
    
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase
    let sharedDB = CKContainer.default().sharedCloudDatabase

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let tableViewFrame = CGRect(x: 0, y: navHeight, width: screenWidth, height: screenHeight - navHeight)
        tableView = UITableView(frame: tableViewFrame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }
    
    func log(_ message: String) {
        DispatchQueue.main.async {
            self.hud.mode = .text
            self.hud.label.text = message
            self.hud.show(animated: true)
            self.hud.hide(animated: true, afterDelay: 2)
        }
    }
    
    func logError(_ error: Error?) {
        guard let error = error as? CKError else {
            return
        }
        
        print(error.localizedDescription)
        
        var errorMessage = error.localizedDescription
        if let errorDescription = error.userInfo["ServerErrorDescription"] as? String {
            errorMessage = errorDescription
        }
        
        DispatchQueue.main.async {
            self.hud.hide(animated: true)
            self.showAlert(with: errorMessage)
        }
    }
    
    func showHUD() {
        DispatchQueue.main.async {
            self.hud.mode = .indeterminate
            self.hud.label.text = nil
            self.hud.show(animated: true)
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            self.hud.hide(animated: true)
        }
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

