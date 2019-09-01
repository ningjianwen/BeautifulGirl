//
//  GirlModel.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 29/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//  all model implementation codable protocol

import Foundation
import ObjectMapper
import RxDataSources

/**
 category = MeiTui;
 "group_url" = "https://www.dbmeinv.com:443/dbgroup/1737011";
 "image_url" = "https://wx3.sinaimg.cn/large/0060lm7Tgy1ftc0odsk55j30dw0ii7b1.jpg";
 objectId = 5b4cc34e0b616000310b6a42;
 "thumb_url" = "https://wx3.sinaimg.cn/small/0060lm7Tgy1ftc0odsk55j30dw0ii7b1.jpg";
 title = "\U597d\U4e27\U554a\Uff0c\U6765\U4e00\U6ce2\U8c46\U6cb9\U5427\U3002";
 */
struct GirlModel: Mappable {
    var category = ApiManager.GirlCategory.GirlCategoryAll
    var group_url = ""
    var title = ""
    var thumb_url = ""
    var image_url = ""
    var objectId = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        category  <- map["category"]
        group_url <- map["group_url"]
        title     <- map["title"]
        thumb_url <- map["thumb_url"]
        image_url <- map["image_url"]
        objectId  <- map["objectId"]
    }
}

struct NJWSection {
    
    var items: [Item]
}

extension NJWSection: SectionModelType {
    
    typealias Item = GirlModel
    init(original: NJWSection, items: [NJWSection.Item]) {
        self = original
        self.items = items
    }
}
