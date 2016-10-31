//
//  HTTPClient.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
  
  let baseUrl = "http://jsonplaceholder.typicode.com/"
  
  func downloadRequestForClass(className: String, completion: ((AnyObject?) -> ())?) {
    let url = baseUrl + className
    
    Alamofire.request(url).validate()
      .responseJSON { (response) -> Void in
        guard response.result.isSuccess else {
          print("Error while fetching data: \(response.result.error)")
          completion?(nil)
          return
        }
        guard let value = response.result.value  else {
          print("Malformed data")
          completion?(nil)
          return
        }
        completion?(value as AnyObject?)
    }
  }
  
}
