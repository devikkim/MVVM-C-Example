//
//  LanguageListViewController.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageListViewController: UIViewController, Storyboarder {
  
  let disposeBag = DisposeBag()
  
  /// Coordinator 로 부터 초기화
  var viewModel: LanguageListViewModel!
  
  @IBOutlet private weak var tableView: UITableView!
  private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    setupUI()
    setupBindings()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupUI(){
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.title = "Choose a language"
    
    tableView.rowHeight = 48.0
  }
  
  private func setupBindings(){
    /// Languages 의 Array 와 테이블 뷰 셀과의 바인딩
    viewModel.languages
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { _, language, cell in
        cell.textLabel?.text = language
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    /// 테이블 셀 선택 바인딩
    tableView
      .rx
      .modelSelected(String.self)
      .bind(to: viewModel.selectLanguage.asObserver())
      .disposed(by: disposeBag)
    
    /// 네비게이션 바 버튼 바인딩
    cancelButton
      .rx
      .tap
      .bind(to: viewModel.cancel.asObserver())
      .disposed(by: disposeBag)
    
  }
}
