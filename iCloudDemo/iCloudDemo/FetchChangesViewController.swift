//
//  FetchChangesViewController.swift
//  iCloudDemo
//
//  Created by YZF on 2019/4/26.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import CloudKit

class FetchChangesViewController: BaseViewController {

    enum Content: String, CaseIterable {
        case fetchDatabaseChanges = "Fetch Database Changes"
    }
    
    let contents: [Content] = Content.allCases
    
    var sharedDBChangeToken: CKServerChangeToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchDatabaseChanges() {
        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: nil) // previously cached
        changesOperation.fetchAllChanges = true
        // collect zone IDs
        changesOperation.recordZoneWithIDChangedBlock = { zoneID in
            print("recordZoneWithIDChangedBlock \(zoneID) \n")
            self.fetchZoneChanges(recordZoneIDs: [zoneID])
        }
        // delete local cache
        changesOperation.recordZoneWithIDWasDeletedBlock = { zoneID in
            print("recordZoneWithIDWasDeletedBlock \(zoneID) \n")
        }
        // cache new token
        changesOperation.changeTokenUpdatedBlock = { token in
            print("changeTokenUpdatedBlock \(token) \n")
        }
        
        changesOperation.fetchDatabaseChangesCompletionBlock = { (newToken: CKServerChangeToken?, more: Bool, error: Error?) in
            // error handling here
            self.sharedDBChangeToken = newToken! // cache new token
//            self.fetchZoneChanges(callback) // using CKFetchRecordZoneChangesOperation
        }
        self.privateDB.add(changesOperation)
    }
    
    func fetchZoneChanges(recordZoneIDs: [CKRecordZone.ID]) {
        // 可以通过 optionsByRecordZoneID 设置 token、resultLimit 等
        let changesOperation = CKFetchRecordZoneChangesOperation(recordZoneIDs: recordZoneIDs, optionsByRecordZoneID: nil)
        
        changesOperation.recordChangedBlock = { record in
            print("recordChangedBlock \(record) \n")
        }
        changesOperation.recordWithIDWasDeletedBlock = { (recordID, recordType) in
            print("recordWithIDWasDeletedBlock \(recordID) \n")
        }
        changesOperation.recordZoneChangeTokensUpdatedBlock = { (zoneID, token, tokenData) in
            print("recordZoneChangeTokensUpdatedBlock \(token!) \n")
        }
        changesOperation.recordZoneFetchCompletionBlock = { (zoneID, token, tokenData, moreComing, error) in
            print("recordZoneFetchCompletionBlock \(token!) \n")
        }
        changesOperation.fetchRecordZoneChangesCompletionBlock = { error in
            print("fetchRecordZoneChangesCompletionBlock \(error!) \n")
        }
        
        self.privateDB.add(changesOperation)
    }

}

// MARK: UITableViewDataSource & UITableViewDelegate
extension FetchChangesViewController {
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.selectionStyle = .none
        
        cell.textLabel?.text = contents[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contents[indexPath.row] {
        case .fetchDatabaseChanges:
            fetchDatabaseChanges()
        }
    }
}
