//
//  RepositoryCell.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var starsCountLabel: UILabel!
  
  func setName(_ name: String){
    nameLabel.text = name
  }
  
  func setDescription(_ description: String){
    descriptionLabel.text = description
  }
  
  func setStarsCount(_ starsCountText: String){
    starsCountLabel.text = starsCountText
  }
  
}
