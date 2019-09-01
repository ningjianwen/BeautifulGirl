//
//  ViewController.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 28/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
import SYPhotoBrowser

let screenWidth: CGFloat = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let itemWidth: CGFloat = (screenWidth - 6) / 3
let cellIdentifier: String = "beautifulGirlCellIdentifier"

class ViewController: UIViewController {
    
    let viewModel = NJWViewModel()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        var cv = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: self.flowLayout)
        cv.backgroundColor = .white
        cv.register(BeautifulGirlCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
    
    
    //创建数据源
    let dataSource = RxCollectionViewSectionedReloadDataSource<NJWSection>(
        configureCell: { (dataSource, collectionView, indexPath, itemModel) in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                          for: indexPath) as! BeautifulGirlCell
            cell.model = itemModel
            cell.setNeedsDisplay() //this line code is must
            return cell
            }
    )
    
    var page: Int = 0
    var category: ApiManager.GirlCategory = .GirlCategoryAll
    let disposeBag = DisposeBag()
    let vmOutput: NJWViewModel.Output? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        bindView()
        navigationItem()
        // 加载数据
        collectionView.mj_header.beginRefreshing()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout.finalizeCollectionViewUpdates()
    }
}

extension ViewController{
    
    fileprivate func setupUI(){
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
    }
    
    fileprivate func navigationItem(){
        let dropdownMenu = SYNavigationDropdownMenu(navigationController: self.navigationController!)
        dropdownMenu?.dataSource = self
        dropdownMenu!.delegate = self
        self.navigationItem.titleView = dropdownMenu
    }
    
    fileprivate func bindView(){
        
        let vmInput = NJWViewModel.NJWInput(category: self.category)
        let vmOutput = viewModel.transform(input: vmInput)
        vmOutput.sections.asDriver().drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        vmOutput.refreshStatus.asObservable().subscribe(onNext: {[weak self] status in
            switch status {
            case .beingHeaderRefresh:
                self?.collectionView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self?.collectionView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                self?.collectionView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.collectionView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
        
//        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(GirlModel.self)).bind(onNext: {[weak self] indexPath, itemModel in
//            var phtoUrlArray: Array<String> = []
//            phtoUrlArray.append(itemModel.image_url)
//            let photoBrowser: SYPhotoBrowser = SYPhotoBrowser(imageSourceArray: phtoUrlArray, caption: nil, delegate: self)
////                photoBrowser.prefersStatusBarHidden = false
////            photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyle
//            photoBrowser.initialPageIndex = UInt(indexPath.item)
//            UIApplication.shared.delegate?.window?!.rootViewController?.present(photoBrowser, animated: true)
//        }).disposed(by: disposeBag)
        collectionView.rx.modelSelected(GirlModel.self).subscribe(onNext:{[weak self] itemModel in

            print("current selected model is \(itemModel)")
            let photoBrowser: SYPhotoBrowser = SYPhotoBrowser(imageSourceArray: [itemModel.image_url], caption: nil, delegate: self)
            //                photoBrowser.prefersStatusBarHidden = false
            //            photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyle
            UIApplication.shared.delegate?.window?!.rootViewController?.present(photoBrowser, animated: true)

        }).disposed(by: disposeBag)
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vmOutput.requestCommand.onNext(true)
//            self.collectionView.reloadData()
        })
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            vmOutput.requestCommand.onNext(false)
        })
    }
}

extension ViewController: SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate{
    func titleArray(for navigationDropdownMenu: SYNavigationDropdownMenu!) -> [String]! {
        return ["所有", "大胸", "翘臀", "黑丝", "美腿", "清新", "杂烩"]
    }
    
    func arrowImage(for navigationDropdownMenu: SYNavigationDropdownMenu!) -> UIImage! {
        return UIImage.init(named: "Arrow")
    }
    func arrowPadding(for navigationDropdownMenu: SYNavigationDropdownMenu!) -> CGFloat {
        return 8.0
    }
    
    func keepCellSelection(for navigationDropdownMenu: SYNavigationDropdownMenu!) -> Bool {
        return false
    }
    
    func navigationDropdownMenu(_ navigationDropdownMenu: SYNavigationDropdownMenu!, didSelectTitleAt index: UInt) {
        self.category = ApiManager.indexToCategory(index: Int(index))
        print("self.category = \(self.category) index =\(index)")
        self.collectionView.mj_header.beginRefreshing()
    }
}

