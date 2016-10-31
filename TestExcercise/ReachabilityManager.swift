//
//  ReachabilityManager.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import Alamofire

final class ReachabilityManager: NSObject {
  var isNetworkReachable: Bool = false
  var reachabilityManager: NetworkReachabilityManager?

  static let sharedInstance: ReachabilityManager = {
    let instance = ReachabilityManager()
    return instance
  }()
  
   private override init() {
    super.init()
    self.startReachabilityObserver()
  }
  
  func startReachabilityObserver() {
    self.reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    reachabilityManager?.listener = { status in
      print("Network Status Changed: \(status)")
      switch status {
      case .notReachable:
        self.isNetworkReachable = false
        NotificationCenter.default.post(name: .networkUnreachable, object: nil)
        break
      case .reachable(_), .unknown:
        self.isNetworkReachable = true
        NotificationCenter.default.post(name: .networkIsReachable, object: nil)
        break
      }
    }
    self.reachabilityManager?.startListening()
  }
  
}
