//
//  RepositoryListCoordinator.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoordinator: Coordinator<Void> {
  private let window: UIWindow
  
  init(window: UIWindow){
    self.window = window
  }
  
  override func start() -> Observable<Void> {
    let viewModel = RepositoryListViewModel(initialLanguage: "Swift")
    let viewController = RepositoryListViewController.initFromStoryboard(name: "Main")
    let navigationController = UINavigationController(rootViewController: viewController)
    
    /// View에 ViewModel 세팅
    viewController.viewModel = viewModel
    
    /// 선택한 Repository에 대한 구독
    viewModel.selectRepository
      .asObservable()
      .map {$0.url}
      .subscribe(onNext: { [weak self] in self?.showRepository(by: $0, in: navigationController) })
      .disposed(by: disposeBag)
    
    /// 네비게이션 바 버튼 클릭에 대한 구독
    viewModel.showLanguageList
      .asObservable()
      .flatMap { [weak self] _ -> Observable<String?> in
        guard let `self` = self else { return .empty() }
        return self.showLanguageList(on: viewController)
      }
      .filter { $0 != nil }
      .map { $0! }
      .bind(to: viewModel.currentLanguage.asObserver())
      .disposed(by: disposeBag)
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    return Observable.never()
  }
  
  private func showRepository(by url: URL, in navigationController: UINavigationController) {
    let safariViewController = SFSafariViewController(url: url)
    navigationController.pushViewController(safariViewController, animated: true)
  }
  
  private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
    let languageListCoordinator = LanguageListCoordinator(rootVC: rootViewController)
    
    /// LanguageListCoordinator 의 start 메소드 실행
    return coordinate(to: languageListCoordinator)
      .map { result in
        switch result {
        case .language(let language): return language
        case .cancel: return nil
        }
    }
  }
}
