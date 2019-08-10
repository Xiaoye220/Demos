//
//  PhotoCell.swift
//  PhotoKitDemo
//
//  Created by YZF on 2018/3/22.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit

class PhotoCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        imageView = UIImageView()
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
