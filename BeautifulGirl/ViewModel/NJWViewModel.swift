//
//  NJWViewModel.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 31/08/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

enum NJWRefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class NJWViewModel: NSObject {
    
    let models = Variable<[GirlModel]>([])
    var index: Int = 1
}

extension NJWViewModel: NJWViewModelType{
    
    typealias Input = NJWInput
    typealias Output = NJWOutput
    
    struct NJWInput {
        
        let category: ApiManager.GirlCategory
        init(category: ApiManager.GirlCategory) {
            self.category = category
        }
    }
    
    struct NJWOutput {
        
        let sections: Driver<[NJWSection]>
        let requestCommand = PublishSubject<Bool>()
        let refreshStatus = Variable<NJWRefreshStatus>(.none)
        
        init(sections: Driver<[NJWSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: NJWViewModel.NJWInput) -> NJWViewModel.NJWOutput {
        let sections = models.asObservable().map{ (models) -> [NJWSection] in
            return [NJWSection(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = Output(sections: sections)
        output.requestCommand.subscribe(onNext: { [unowned self] isReloadData in
            self.index = isReloadData ? 0 : self.index + 1
            NJWNetTool.rx.request(.requestWithcategory(type: input.category, index: self.index))
            .asObservable()
            .mapArray(GirlModel.self)
            .subscribe({[weak self] (event) in
                    switch event{
                     
                    case let .next(modelArr):
                        self?.models.value = isReloadData ? modelArr : (self?.models.value ?? []) + modelArr
                        NJWProgressHUD.showSuccess("加载成功")
                    case let .error(error):
                        NJWProgressHUD.showError(error.localizedDescription)
                    case .completed:
                        output.refreshStatus.value = isReloadData ? NJWRefreshStatus.endHeaderRefresh : NJWRefreshStatus.endFooterRefresh
                    }
                }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return output
    }
}
