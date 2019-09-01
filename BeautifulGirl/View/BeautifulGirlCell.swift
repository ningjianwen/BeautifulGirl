//
//  BeautifulGirlCell.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 29/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//  show girl image cell

import UIKit
import Kingfisher

class BeautifulGirlCell: UICollectionViewCell {
    
    lazy var imgview: UIImageView = {
        var img = UIImageView.init(frame: self.frame)
        img.contentMode = .scaleToFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue
        self.contentView.addSubview(self.imgview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgview.frame = bounds
    }
    
    var model: GirlModel?{
        didSet{
          guard let model = model else { return }
            self.imgview.kf.setImage(with: URL(string: model.thumb_url ))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
