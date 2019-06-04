//
//  ApiManager.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 02/06/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//

import Foundation
import Moya

enum ApiManager {
    case requestWithcategory(String,Int)
}

extension ApiManager: TargetType{
    var baseURL: URL{
        return URL(string: "https://meizi.leanapp.cn")!
    }
    var task: Task{
        return .requestPlain
    }
    var headers: [String : String]?{
        return ["Content-type": "application/json"]
    }
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String{
        switch self{
        case .requestWithcategory(let category,let page):
            return "/category/\(category)/page/\(page)"
        }
    }
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "ningjianwen".data(using: String.Encoding.utf8)!
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}
