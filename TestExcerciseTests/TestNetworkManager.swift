//
//  TestNetworkManager.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import Alamofire
import XCTest

@testable import TestExcercise

class TestNetworkManager: XCTestCase {
  
  func testdownloadRequestForClass() {
    let testExpectation = expectation(description: "NetworkManager")

    let networkManager = NetworkManager()
    networkManager.downloadRequestForClass(className: "Posts", completion: { value in
      XCTAssertNotNil(value, "Expected non-nil value")
      testExpectation.fulfill()
    })
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
}
