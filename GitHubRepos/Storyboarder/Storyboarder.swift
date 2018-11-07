//
//  Storyboarder.swift
//  GitHubRepos
//
//  Created by InKwon on 2018. 9. 19..
//  Copyright © 2018년 leibniz. All rights reserved.
//

import UIKit

protocol Storyboarder {
  static var storyboardID: String {get}
}

extension Storyboarder where Self: UIViewController {
  static var storyboardID: String {
    return String(describing: Self.self)
  }
  
  static func initFromStoryboard(name: String) -> Self{
    let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
    
    return storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
  }
}
