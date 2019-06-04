//
//  BeautifulGirlCell.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 29/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//

import UIKit
import Kingfisher

class BeautifulGirlCell: UICollectionViewCell {
    
    lazy var imgview: UIImageView = {
        var img = UIImageView.init(frame: self.frame)
        return img
    }()
    
    var girlModel: GirlModel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .gray
        self.contentView.addSubview(self.imgview)
    }
    
//    var model: GirlModel!{
//        set(newValue){
//            self.girlModel = newValue
//            self.imgview.kf.setImage(with: URL(string: newValue.thumb_url ?? ""))
////            self.setNeedsDisplay()
//        }
//        get{
//            return self.girlModel
//        }
//    }
    var model: GirlModel!{
        didSet{
          self.imgview.kf.setImage(with: URL(string: model.thumb_url ?? ""))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
