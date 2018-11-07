//
//  RepositoryListViewModel.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {
  
  /// 새로고침 Observer
  let reload: AnyObserver<Void>
  
  /// 네비게이션 타이틀 및 선택 언어 Subject
  let currentLanguage: BehaviorSubject<String>!
  
  /// language modal을 띄우기 위한 Subject
  let showLanguageList = PublishSubject<Void>()
  
  /// 테이블셀을 선택할때 사용될 Subject
  let selectRepository = PublishSubject<RepositoryViewModel>()
  
  /// 선택 언어에 따른 Repositories를 다루는 Observable
  let repositories: Observable<[RepositoryViewModel]>
  
  let alertMessage: Observable<String>
  
  init(initialLanguage: String, githubService: GithubService = GithubService()){
    let _reload = PublishSubject<Void>()
    self.reload = _reload.asObserver()
    
    self.currentLanguage = BehaviorSubject<String>(value: initialLanguage)
    
    let _alertMessage = PublishSubject<String>()
    self.alertMessage = _alertMessage.asObservable()
    
    self.repositories = Observable.combineLatest(_reload, self.currentLanguage) { _, language in language }
      .flatMapLatest{ language in
        githubService.getMostPopularRepositories(byLanguage: language)
          .catchError{error in
            _alertMessage.onNext(error.localizedDescription)
            return Observable.empty()
        }
      }
      .map {repositories in repositories.map(RepositoryViewModel.init)}
  }
}
