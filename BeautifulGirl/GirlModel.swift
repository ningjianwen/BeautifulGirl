//
//  GirlModel.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 29/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//

import Foundation

struct ListModel: Codable {
    var category: String?
    var page: Int?
    var results: [GirlModel]
}

struct GirlModel: Codable {
    var title: String?
    var thumb_url: String?
    var image_url: String?
}
