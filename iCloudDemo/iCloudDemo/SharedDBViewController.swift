//
//  ViewController.swift
//  iCloudDemo
//
//  Created by Xiaoye220 on 01/02/2019.
//  Copyright (c) 2019 Xiaoye220. All rights reserved.
//

import UIKit
import CloudKit

/// 简单的增删改查
class SharedDBViewController: BaseViewController {
    
    enum Content: String, CaseIterable {
        case createCustomZone = "Create Custom Zone"
        case newShare = "Inviting Participants to a New Share"
        case participantManager = "Participant Manager"
        case deleteShareRecord = "Delete Share Record"
        case updateShareRecord = "Update Share Record"
    }
    
    let contents: [[Content]] = [[.createCustomZone],
                                 [.newShare, .participantManager],
                                 [.deleteShareRecord, .updateShareRecord]]

    // 记录名，是一条记录的唯一标识符
    let recordName = "Tommy_Shared_RecordName"
    // 记录类型，类似数据库的 table
    let recordType = "Person"
    // 自定义 Zone 的标识符，只对 privateCloudDatabase
    let sharedZoneName = "sharedZone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iCloudNewShare() {
        let zoneID = CKRecordZone.ID.init(zoneName: sharedZoneName, ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID.init(recordName: recordName, zoneID: zoneID)
        let rootRecord = CKRecord(recordType: recordType, recordID: recordID)
        rootRecord.setValue("Tommy", forKey: "name")
        rootRecord.setValue(28, forKey: "age")
        
        let shareRecord = CKShare(rootRecord: rootRecord)
        let recordsToSave = [rootRecord, shareRecord]

        
        let sharingController = UICloudSharingController.init { [weak self] (controller, completion) in
            let operation = CKModifyRecordsOperation(recordsToSave:recordsToSave, recordIDsToDelete: nil)
            operation.perRecordCompletionBlock = { (record, error) in
                if let error = error {
                    print(error)
                }
            }
            operation.modifyRecordsCompletionBlock = { (records, recordID, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        controller.dismiss(animated: true, completion: nil)
                    }
                    self?.logError(error)
                } else {
                    completion(shareRecord, CKContainer.default(), nil)
                }
            }
            self?.privateDB.add(operation)
        }

        sharingController.availablePermissions = [.allowReadWrite, .allowPrivate]
        sharingController.delegate = self
        self.present(sharingController, animated:true, completion:nil)
    }
    
    func iCloudShareParticipantManager() {
        let zoneID = CKRecordZone.ID.init(zoneName: sharedZoneName, ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID.init(recordName: recordName, zoneID: zoneID)
        
        showHUD()
        privateDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.logError(error)
                return;
            }
            if let shareReference = record!.share {
                self.privateDB.fetch(withRecordID: shareReference.recordID) { (record, error) in
                    guard let shareRecord = record as? CKShare else {
                        if let error = error {
                            self.logError(error)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let sharingController = UICloudSharingController(share: shareRecord, container: CKContainer.default())
                        self.present(sharingController, animated:true, completion:nil)
                        self.hideHUD()
                    }
                }
            }
        }
        
    }
    
    func iCloudCreateCustomZone() {
        let customZone  = CKRecordZone(zoneName: sharedZoneName)
        
        showHUD()
        privateDB.save(customZone) { [weak self] (zone, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("create zone success")
            }
        }
    }
    
    func iCloudShareRecordDelete() {
        let zoneID = CKRecordZone.ID.init(zoneName: sharedZoneName, ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID.init(recordName: recordName, zoneID: zoneID)
        
        showHUD()
        privateDB.delete(withRecordID: recordID) { [weak self] (_, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("delete success")
            }
        }
    }
    
    func iCloudShareRecordUpdate() {
        let zoneID = CKRecordZone.ID.init(zoneName: sharedZoneName, ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID.init(recordName: recordName, zoneID: zoneID)
        
        showHUD()
        privateDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                record!.setValue(20, forKey: "age")
                record!.setValue("Lily", forKey: "name")
                self?.privateDB.save(record!) { (record, error) in
                    if let error = error {
                        self?.logError(error)
                    } else {
                        self?.log("update success")
                    }
                }
            }
        }
    }
    
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SharedDBViewController {
    
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
        switch contents[indexPath.section][indexPath.row] {
        case .createCustomZone:
            iCloudCreateCustomZone()
        case .newShare:
            iCloudNewShare()
        case .participantManager:
            iCloudShareParticipantManager()
        case .deleteShareRecord:
            iCloudShareRecordDelete()
        case .updateShareRecord:
            iCloudShareRecordUpdate()
        }
    }
}

extension SharedDBViewController: UICloudSharingControllerDelegate {
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print(error)
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Shared Item"
    }
    
    func itemThumbnailData(for: UICloudSharingController) -> Data? {
        // This sets the image in the middle, nil is the default document image you see, this method is not required
        return nil
    }
}
