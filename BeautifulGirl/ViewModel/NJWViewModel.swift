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
    var index: Int = 0
}

extension NJWViewModel: NJWViewModelType{
    
    typealias Input = NJWInput
    typealias Output = NJWOutput
    
    struct NJWInput {
        
        var category = BehaviorRelay<ApiManager.GirlCategory>(value: .GirlCategoryAll)
        init(category: BehaviorRelay<ApiManager.GirlCategory>) {
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
        input.category.asObservable().subscribe{
          
            let category = $0.element
            
            output.requestCommand.subscribe(onNext: { [unowned self] isReloadData in
                self.index = isReloadData ? 0 : self.index + 1
                NJWNetTool.rx.request(.requestWithcategory(type: category!, index: self.index))
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
            }).disposed(by: self.rx.disposeBag)
            
        }.disposed(by: rx.disposeBag)
        
        return output
    }
}
