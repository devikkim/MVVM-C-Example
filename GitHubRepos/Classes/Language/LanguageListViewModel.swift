//
//  LanguageListViewModel.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import RxSwift

class LanguageListViewModel {
  /// 선택한 언어에 대한 Subject
  let selectLanguage = PublishSubject<String>()
  
  /// 취소버튼에 대한 Subject
  let cancel = PublishSubject<Void>()
  
  /// Github로 부터 받은 Repositories 의 Observable
  let languages: Observable<[String]>
  
  init(githubService: GithubService = GithubService()) {
    self.languages = githubService.getLanguageList()
  }
}
