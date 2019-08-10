//
//  GetCollectionViewController.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/22.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Photos

class GetCollectionViewController: UIViewController {

    var tableView: UITableView!
    
    var assetCollection: PHFetchResult<PHAssetCollection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: CGRect(x: 0, y: topHeight, width: screenWidth, height: screenHeight - topHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        getAllAlbums()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAllAlbums() {
        PhotoKitUtils.doWithPhotoAuthorized {
            // 列出所有系统的智能相册
            let options = PHFetchOptions()
            self.assetCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
            self.tableView.reloadData()
        }
    }
    
}

extension GetCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        if let collection = assetCollection?[indexPath.row] {
            // ⚠️⚠️⚠️ 获取相簿中的 PHAsset
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            cell.textLabel?.text = collection.localizedTitle! + " (\(assets.count))"
        }
        return cell
    }
}
