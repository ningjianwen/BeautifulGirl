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
    
    enum GirlCategory: String{
        
        case GirlCategoryAll = "All"
        case GirlCategoryDaXiong = "DaXiong"
        case GirlCategoryQiaoTun = "QiaoTun"
        case GirlCategoryHeisi = "Heisi"
        case GirlCategoryMeiTui = "MeiTui"
        case GirlCategoryQingXin = "QingXin"
        case GirlCategoryZaHui = "ZaHui"
    }
    case requestWithcategory(type: GirlCategory, index: Int)
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
            return "/category/\(category.rawValue)/page/\(page)" //此处因为是枚举值，必须使用category.rawValue，否则请求不到数据
        }
    }
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
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

let NJWNetTool = MoyaProvider<ApiManager>()

