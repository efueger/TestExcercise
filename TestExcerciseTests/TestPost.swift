//
//  TestPost.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest

@testable import TestExcercise

class TestPost: XCTestCase {

  func testprocessJsonrecordsToArray() {
    if let file = Bundle.main.path(forResource: "Data", ofType: "json") {
      let testData = try? Data(contentsOf: URL(fileURLWithPath: file))
      let parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: testData)
       let posts = Post.processJsonrecordsToArray(jsonRecords: parsedResponse!)
       XCTAssertEqual(posts.count, 1)
    }
  }
  
  func testprocessJsonrecordsToArrayForEmptyArray() {
    if let file = Bundle.main.path(forResource: "Data", ofType: "json") {
      let testData = try? Data(contentsOf: URL(fileURLWithPath: file))
      var parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: testData)
      parsedResponse?.removeAll()
      let posts = Post.processJsonrecordsToArray(jsonRecords: parsedResponse!)
      XCTAssertEqual(posts.count, 0)
    }
  }
  
}
