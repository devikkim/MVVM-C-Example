//
//  LanguageListCoordinator.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import Foundation
import RxSwift

enum LanguageListCoordinationResult {
  case language(String)
  case cancel
}

class LanguageListCoordinator: Coordinator<LanguageListCoordinationResult> {
  private let rootVC: UIViewController
  
  init(rootVC: UIViewController){
    self.rootVC = rootVC
  }
  
  override func start() -> Observable<CoordinationResult> {
    let vc = LanguageListViewController.initFromStoryboard(name: "Main")
    let navigationController = UINavigationController(rootViewController: vc)
    
    let viewModel = LanguageListViewModel()
    vc.viewModel = viewModel
    
    /// 네비게이션 바 탭에 따른 구독
    let cancel = viewModel.cancel.asObservable()
      .map{_ in CoordinationResult.cancel}
    
    /// 선택한 Language에 따른 구독
    let language = viewModel.selectLanguage.asObservable()
      .map {CoordinationResult.language($0)}
    
    rootVC.present(navigationController, animated: true)
    
    return Observable.merge(cancel, language)
      .take(1)
      .do(onNext: {[weak self] _ in self?.rootVC.dismiss(animated: true)})
  }
}
