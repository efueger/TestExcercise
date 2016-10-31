//
//  NotificationExtension.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 28/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation

extension NSNotification.Name {
  
  static let dbSyncCompleted = Notification.Name("on-sync-complete")
  static let networkIsReachable = Notification.Name("network-reachable")
  static let networkUnreachable = Notification.Name("network-unreachable")
}
