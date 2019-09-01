//
//  NJWViewModelType.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 31/08/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//  VM need implementation this protocol

import Foundation

protocol NJWViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
