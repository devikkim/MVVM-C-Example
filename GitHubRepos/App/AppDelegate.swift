//
//  AppDelegate.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var appCoordinator: AppCoordinator!
  private let disposeBag = DisposeBag()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    
    appCoordinator = AppCoordinator(window: window!)
    appCoordinator.start()
      .subscribe()
      .disposed(by: disposeBag)
    
    return true
  }
}

