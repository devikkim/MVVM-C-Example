//
//  RepositoryListViewController.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RepositoryListViewController: UIViewController, Storyboarder {
  
  @IBOutlet private weak var tableView: UITableView!
  private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
  private let refreshControl = UIRefreshControl()
  
  /// Coordinator 로 부터 초기화
  var viewModel: RepositoryListViewModel!
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
    setBindings()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  private func setUI(){
    navigationItem.rightBarButtonItem = chooseLanguageButton
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    tableView.insertSubview(refreshControl, at: 0)
  }
  
  private func setBindings(){
    /// Github 로 부터 받은 데이터를 테이블 셀 바인딩
    viewModel.repositories
      .observeOn(MainScheduler.instance)
      .do(onNext: {[weak self] _ in self?.refreshControl.endRefreshing()})
      .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { [weak self] _, repo, cell in
        self?.setupRepositoryCell(cell, repository: repo)
      }
      .disposed(by: disposeBag)
    
    /// 네비게이션 타이틀에 현재선택 언어 바인딩
    viewModel.currentLanguage
      .asObservable()
      .map{"\($0)"}
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    /// 페이지 새로고침에 따른 바인딩
    refreshControl
      .rx
      .controlEvent(.valueChanged)
      .bind(to: viewModel.reload)
      .disposed(by: disposeBag)
    
    /// 네비게이션 바 버튼 바인딩
    chooseLanguageButton
      .rx
      .tap
      .bind(to: viewModel.showLanguageList.asObserver())
      .disposed(by: disposeBag)
    
    /// 테이블 셀 선택 바인딩
    tableView
      .rx
      .modelSelected(RepositoryViewModel.self)
      .bind(to: viewModel.selectRepository.asObserver())
      .disposed(by: disposeBag)
    
    /// 오류메세지 구독
    viewModel.alertMessage
      .subscribe(onNext: {[weak self] in self?.presentAlert(message: $0)})
      .disposed(by: disposeBag)
    
  }
  
  private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
    cell.selectionStyle = .none
    cell.setName(repository.name)
    cell.setDescription(repository.description)
    cell.setStarsCount(repository.starsCountText)
  }
  
  private func presentAlert(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true)
  }
}
