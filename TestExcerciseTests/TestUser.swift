//
//  TestUser.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest

@testable import TestExcercise

class TestUser: XCTestCase {
  
  func testprocessJsonrecordsToArrayForUser() {
    if let file = Bundle.main.path(forResource: "UserJson", ofType: "json") {
      let testData = try? Data(contentsOf: URL(fileURLWithPath: file))
      let parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: testData)
      let user = User.processJsonrecordsToArray(jsonRecords: parsedResponse!)
      XCTAssertEqual(user.count, 1)
    }
  }
  
  func testprocessJsonrecordsToArrayForEmptyArray() {
    if let file = Bundle.main.path(forResource: "Data", ofType: "json") {
      let testData = try? Data(contentsOf: URL(fileURLWithPath: file))
      var parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: testData)
      parsedResponse?.removeAll()
      let user = User.processJsonrecordsToArray(jsonRecords: parsedResponse!)
      XCTAssertEqual(user.count, 0)
    }
  }
}
