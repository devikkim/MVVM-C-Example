//
//  AppCoordinator.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator<Void> {
  private let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() -> Observable<Void> {
    let repositoryListCoordinator = RepositoryListCoordinator(window: window)
    
    /// RepositoryListCoordinator의 start 메소드 실행
    return coordinate(to: repositoryListCoordinator)
  }
}
