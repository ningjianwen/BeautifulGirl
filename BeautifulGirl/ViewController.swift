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
import MJRefresh

let screenWidth: CGFloat = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let itemWidth: CGFloat = (screenWidth - 6) / 3
let cellIdentifier: String = "beautifulGirlCellIdentifier"

class ViewController: UIViewController {
    
    let provider = MoyaProvider<ApiManager>()
    
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
    
    var page: Int = 0
    var category: GirlCategory = .GirlCategoryAll
    let disposeBag = DisposeBag()
    var dataArr = [GirlModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self
        
        //上拉加载和下拉刷新
        self.collectionView.mj_header = MJRefreshNormalHeader()
        self.collectionView.mj_footer = MJRefreshAutoNormalFooter()
        self.collectionView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(collectionViewPullToRefreshAction))
        self.collectionView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(collectionViewLoadMoreAction))
        self.collectionView.mj_header.beginRefreshing()
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BeautifulGirlCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BeautifulGirlCell
        
        if(indexPath.item < self.dataArr.count){
            let model: GirlModel = self.dataArr[indexPath.item]
            cell.imgview.kf.setImage(with: URL(string: model.thumb_url ?? ""))
        }
        return cell
    }
}

extension ViewController{
    
    /// 上拉加载更多数据
    @objc func collectionViewLoadMoreAction() {
        self.page = self.page + 1
        provider.rx
            .request(.requestWithcategory(self.category.rawValue, self.page))
            .mapModel(ListModel.self)
            .subscribe(onSuccess: { (listModel) in
                self.dataArr += listModel.results
                self.collectionView.mj_footer?.endRefreshing()
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    /// 下拉刷新数据
    @objc func collectionViewPullToRefreshAction() {
        provider.rx
            .request(.requestWithcategory(self.category.rawValue, 0))
            .mapModel(ListModel.self)
            .subscribe(onSuccess: { (listModel) in
                self.dataArr.removeAll() //clean dataArr
                self.dataArr = listModel.results
                self.collectionView.mj_header?.endRefreshing()
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }
}

