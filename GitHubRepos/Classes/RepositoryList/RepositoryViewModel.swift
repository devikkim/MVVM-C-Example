//
//  RepositoryViewModel.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import Foundation

class RepositoryViewModel {
  let name: String
  let description: String
  let starsCountText: String
  let url: URL
  
  init(repository: Repository) {
    self.name = repository.fullName
    self.description = repository.description
    self.starsCountText = "⭐️ \(repository.starsCount)"
    self.url = URL(string: repository.url)!
  }
}
