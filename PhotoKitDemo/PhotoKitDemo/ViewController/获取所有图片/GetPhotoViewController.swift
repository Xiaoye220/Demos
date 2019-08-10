//
//  GetPhotoViewController_1.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/22.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import Photos

class GetPhotoViewController: UIViewController {

    var collectionView: UICollectionView!
    
    /// 取得的资源结果，用了存放的PHAsset
    var assetsFetchResults: PHFetchResult<PHAsset>?
    /// 缩略图大小
    var assetGridThumbnailSize: CGSize!
    /// 带缓存的图片管理对象
    var imageManager: PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        collectionView = UICollectionView(frame: CGRect(x: 0, y: topHeight, width: screenWidth, height: screenHeight - topHeight),
                                          collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        
        if assetsFetchResults == nil {
            getAllPhotos()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// collectionView 布局,同时获取缩略图 size
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let lineNum: CGFloat = 4
        let cellSpacing: CGFloat = 20
        let itemWidth = (screenWidth - (lineNum + 1) * cellSpacing) / 4
        assetGridThumbnailSize = CGSize(width: itemWidth, height: itemWidth)
        layout.itemSize = assetGridThumbnailSize
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing, cellSpacing, 0, cellSpacing)
        return layout
    }
    
    func getAllPhotos() {
        PhotoKitUtils.doWithPhotoAuthorized {
            let allPhotosOptions = PHFetchOptions()
            //按照创建时间倒序排列
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            //只获取图片
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            self.assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
            
            // 初始化和重置缓存, 使用缓存可以快速获取照片或视频
            self.imageManager = PHCachingImageManager()
            self.resetCachedAssets()
            
            //collection view 重新加载数据
            DispatchQueue.main.async{
                self.collectionView?.reloadData()
            }
        }
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }

}

extension GetPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell
        
        if let asset = self.assetsFetchResults?[indexPath.row] {
            let option = PHImageRequestOptions()
            // 照片质量
            option.deliveryMode = .fastFormat
            // 照片大小
            option.resizeMode = .fast
            // 是否同步
            option.isSynchronous = false
            // ⚠️⚠️⚠️ 获取缩略图, targetSize 设置为 PHImageManagerMaximumSize 可以获取原图
            self.imageManager.requestImage(for: asset,
                                           targetSize: assetGridThumbnailSize,
                                           contentMode: PHImageContentMode.aspectFill,
                                           options: option) { (image, info) in
                                            cell.image = image
            }
        }
        
        return cell
    }
    
    // 点击图片查看图片详情
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assetsFetchResults![indexPath.row]
        
        //获取图片名
        PHImageManager.default()
            .requestImageData(for: asset, options: nil) { imageData, dataUTI, orientation, info in
                let imageName = (info?["PHImageFileURLKey"] as? URL)?.lastPathComponent
                print("图片名称: \(imageName ?? "")")
        }
        
        print("日期：\(asset.creationDate!)\n"
            + "类型：\(asset.mediaType.rawValue)\n"
            + "位置：\(asset.location?.coordinate.latitude ?? 0), \(asset.location?.coordinate.longitude ?? 0)\n"
            + "时长：\(asset.duration)\n")
    }
}
