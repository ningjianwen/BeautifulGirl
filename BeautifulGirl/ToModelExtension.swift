//
//  ToModelExtension.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 02/06/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//  JSON -> Model

import Foundation
import Moya
import RxSwift

extension Response{
    //JSON -> Model
    func mapModel<T: Codable>(_ type: T.Type) throws -> T {
        print(String.init(data: data, encoding: .utf8) ?? "")
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait,ElementType == Response{
    func mapModel<T: Codable>(_ type: T.Type) ->Single<T>{
        return flatMap{response -> Single<T> in
            return Single.just(try response.mapModel(T.self))
        }
    }
}
