//
//  GithubService.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
  case connotParse
}

class GithubService {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared){
    self.session = session
  }
  
  func getLanguageList() -> Observable<[String]> {
    return Observable.just([
      "Swift",
      "Objective-C",
      "Java",
      "C",
      "C++",
      "Python",
      "C#"
      ])
  }
  
  func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]>{
    let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
    
    return session
      .rx
      .json(url: url)
      .flatMap{ json throws -> Observable<[Repository]> in
      guard
        let json = json as? [String: Any],
        let itemsJSON = json["items"] as? [[String: Any]]
        else {
          return Observable.error(ServiceError.connotParse)
        }
        
        let repositories = itemsJSON.compactMap(Repository.init)
        return Observable.just(repositories)
    }
  }
  
}
