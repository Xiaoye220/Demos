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
class SimpleViewController: BaseViewController {
    
    enum Content: String, CaseIterable {
        case saveWithID = "Save With The Specified CKRecord.ID"
        case saveWithoutID = "Save Without CKRecord.ID"
        case fetch = "Fetch With CKRecord.ID"
        case update = "Update With CKRecord.ID"
        case delete = "Delete With CKRecord.ID"
        case performQueue = "Search The Records With CKQuery"
        case createCustomZone = "Create Custom Record Zone"
        case saveToCustomZone = "Save Record To Custom Zone"
    }
        
    let contents: [[Content]] = [[.saveWithID, .saveWithoutID, .fetch, .update, .delete],
                                 [.performQueue],
                                 [.createCustomZone, .saveToCustomZone]]
    
    var currentDB: CKDatabase!
    
    // 记录名，是一条记录的唯一标识符
    let recordName = "Tommy_RecordName"
    // 记录类型，类似数据库的 table
    let recordType = "Person"
    // 自定义 Zone 的标识符，只对 privateCloudDatabase
    let customZoneName = "customZone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentDB == nil {
            currentDB = publicDB
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iCloudSave(_ withId: Bool) {
        var record: CKRecord
        
        // 指定 recordID 会将 record name 设置为上述 "Tommy_RecordName"，这个是唯一标识符，对同一 recordID 保存两次会报错
        // 不指定 recordID 会默认生成一串唯一字符串作为 record name
        if withId {
            let recordID = CKRecord.ID.init(recordName: recordName)
            record = CKRecord(recordType: recordType, recordID: recordID)
        } else {
            record = CKRecord(recordType: recordType)
        }
        
        record.setValue("Tommy", forKey: "name")
        record.setValue(18, forKey: "age")

        showHUD()
        currentDB.save(record) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("save success")
            }
        }
        
//        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
//        operation.modifyRecordsCompletionBlock = { (records, idArr, error) in
//            // TODO
//        }
//        operation.perRecordCompletionBlock = { (record, error) in
//            // TODO
//        }
//        database.add(operation)
    }
    
    func iCloudFetch() {
        let recordID = CKRecord.ID.init(recordName: recordName)
        
        showHUD()
        currentDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("fetch success")
            }
        }
        
//        let operation = CKFetchRecordsOperation(recordIDs: [recordID])
//        operation.perRecordCompletionBlock = { (record, recordID, error) in
//
//        }
//        operation.fetchRecordsCompletionBlock = { (recordIDs, error) in
//
//        }
//        database.add(operation)
    }
    
    func iCloudPerformQueue() {
        // 通过这种方式查询数据需要在 dashboard 中的 indexs 中将查询的字段 name 设置为 queryable，否则会报错
        let queue = CKQuery(recordType: recordType, predicate: NSPredicate(format: "name == %@", "Lily"))
        
        showHUD()
        currentDB.perform(queue, inZoneWith: nil) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("perform queue success")
            }
        }
    }
    
    func iCloudUpdate() {
        let recordID = CKRecord.ID.init(recordName: recordName)
        
        showHUD()
        currentDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                record!.setValue(20, forKey: "age")
                self?.currentDB.save(record!) { (record, error) in
                    if let error = error {
                        self?.logError(error)
                    } else {
                        self?.log("update success")
                    }
                }
            }
        }
    }
    
    func iCloudDelete() {
        let recordID = CKRecord.ID.init(recordName: recordName)
        
        showHUD()
        currentDB.delete(withRecordID: recordID) { [weak self] (recordID, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("delete success")
            }
        }
    }
    
    func iCloudCreateCustomZone() {
        let customZone  = CKRecordZone(zoneName: customZoneName)

        currentDB.save(customZone) { [weak self] (zone, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("create zone success")
            }
        }
    }
    
    func iCloudSaveRecordToCustomZone() {
        let zoneID = CKRecordZone.ID.init(zoneName: customZoneName, ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID.init(recordName: recordName, zoneID: zoneID)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        currentDB.save(record) { [weak self] (record, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("save record to custom zone success")
            }
        }
    }
    
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SimpleViewController {
    
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
        case .saveWithID:
            iCloudSave(true)
        case .saveWithoutID:
            iCloudSave(false)
        case .fetch:
            iCloudFetch()
        case .performQueue:
            iCloudPerformQueue()
        case .update:
            iCloudUpdate()
        case .delete:
            iCloudDelete()
        case .createCustomZone:
            iCloudCreateCustomZone()
        case .saveToCustomZone:
            iCloudSaveRecordToCustomZone()
        }
    }
}

