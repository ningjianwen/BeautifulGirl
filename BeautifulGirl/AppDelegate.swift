//
//  AppDelegate.swift
//  BeautifulGirl
//
//  Created by jianwen ning on 28/05/2019.
//  Copyright © 2019 jianwen ning. All rights reserved.
//  这是一个练习项目，也算是一份福利吧

import UIKit
import RxCocoa
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        let navigationVC = UINavigationController.init(rootViewController: ViewController())
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        NJWProgressHUD.initNJWProgressHUD()
//        testFilter()
//        testFlatMap()
        testGroupBy()
        return true
    }
    
    func testFilter(){
        
        // 筛选出字符串的长度小于10的字符串
        let stringArray = ["Objective-C", "Swift", "HTML", "CSS", "JavaScript"]
        func stringCountLess10(string: String) -> Bool {
            return string.count < 10
        }
        let arr1 = stringArray.filter(stringCountLess10)
        print("arr1: \(arr1)")
        let arr2 = stringArray.filter({string -> Bool in
            return string.count < 10
        })
        print("arr2: \(arr2)")
        // $0表示数组中的每一个元素
        let arr3 = stringArray.filter{
            return $0.count < 10
        }
        print("arr1: \(arr3)")
    }
    
    func testFlatMap(){
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        let disposeBag = DisposeBag()
        
        variable.asObservable()
            .flatMapFirst { $0 }
            .subscribe(onNext: { print("current value: \($0)") })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject1.onNext("C")
    }
    
    func testGroupBy(){
        
        let disposeBag = DisposeBag()
        //将奇数偶数分成两组
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        print("key：\(group.key)    event：\(event)")
                    })
                        .disposed(by: disposeBag)
                default:
                    print("")
                }
            }
            .disposed(by: disposeBag)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

