//
//  TestSyncEngine.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON
import XCTest

@testable import TestExcercise

class TestSyncEngine: XCTestCase {
  
  func testprocessResponseFromServerForNilResponse() {
    let parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: "")
    XCTAssertNil(parsedResponse)
  }
  
  func testprocessResponseFromServerForResponse() {
    if let file = Bundle.main.path(forResource: "Data", ofType: "json") {
      let testData = try? Data(contentsOf: URL(fileURLWithPath: file))
      let parsedResponse = SyncEngine.sharedInstance.processResponseFromServer(response: testData)
      XCTAssertEqual(parsedResponse?.count, 1)
    }
  }
  
}
