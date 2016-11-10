//
//  UINavigationControllerDelegate.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 08/11/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  
  var customNavigationAnimationController = CustomNavigationAnimationController()
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     customNavigationAnimationController.reverse = operation == .pop
    return customNavigationAnimationController
  }
  
}
