//
//  SubscriptionViewController.swift
//  iCloudDemo
//
//  Created by YZF on 2019/1/3.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

/// 订阅通知，当其他设备修改了 iCloud 会受到推送通知
class SubscriptionViewController: BaseViewController {
    
    // 记录名，是一条记录的唯一标识符
    let recordName = "Tommy_RecordName"
    // 记录类型，类似数据库的 table
    let recordType = "Person"
    
    let subscriptionID = "public-changes"
    
    enum Content: String, CaseIterable {
        case saveSubscription = "Save Subscription"
        case registerPushNotification = "Register Push Notification"
    }
    
    let contents: [Content] = Content.allCases

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func iCloudSaveSubscription() {
        let predicate = NSPredicate(format: "name == %@", "Tommy")
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: [CKQuerySubscription.Options.firesOnRecordDeletion, CKQuerySubscription.Options.firesOnRecordCreation, CKQuerySubscription.Options.firesOnRecordUpdate])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        // 开启静默推送
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.alertBody = "Tommy"
        notificationInfo.shouldBadge = true
        
        subscription.notificationInfo = notificationInfo
        
        showHUD()
        publicDB.save(subscription) { [weak self] (subscription, error) in
            if let error = error {
                self?.logError(error)
            } else {
                self?.log("save subscription success")
            }
        }
    }
    
    func iCloudRegisterPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if !accepted {
                self.log("用户不允许消息通知")
            }
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SubscriptionViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        case .saveSubscription:
            iCloudSaveSubscription()
        case .registerPushNotification:
            iCloudRegisterPushNotification()
        }
    }
}

