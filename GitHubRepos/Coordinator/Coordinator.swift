//
//  Coordinator.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import Foundation
import RxSwift

class Coordinator<ResultType>{
  typealias CoordinationResult = ResultType
  
  let disposeBag = DisposeBag()
  
  /// 고유 아이디
  private let identifier = UUID()
  
  private var childCoordinators = [UUID: Any]()
  
  private func store<T>(coordinator: Coordinator<T>){
    childCoordinators[coordinator.identifier] = coordinator
  }
  
  private func free<T>(coordinator: Coordinator<T>){
    childCoordinators[coordinator.identifier] = nil
  }
  
  func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
    store(coordinator: coordinator)
    return coordinator.start()
      .do(onNext: { [weak self] _ in
        self?.free(coordinator: coordinator)
      })
  }
  
  func start() -> Observable<ResultType> {
    fatalError("Start method should be implemented.")
  }
}

