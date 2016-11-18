//
//  UINavigationControllerDelegate.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 08/11/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  
  let customNavigationAnimationController = CustomNavigationAnimationController()
  let customInteractionController = CustomInteractionController()
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   if operation == .push {
      customInteractionController.attachToViewController(viewController: toVC)
    }
     customNavigationAnimationController.reverse = operation == .pop
    return customNavigationAnimationController
  }
  
  func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return customInteractionController.transitionInProgress ? customInteractionController : nil
  }
  
}
