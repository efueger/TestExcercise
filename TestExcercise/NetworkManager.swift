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
  
  func downloadRequestForClass(className: String, completion: @escaping (AnyObject?, Error?) -> ()) -> Void {
    let url = baseUrl + className.appending("s")
    
    Alamofire.request(url).validate()
      .responseJSON { (response) -> Void in
        guard response.result.isSuccess else {
          print("Error while fetching data: \(response.result.error)")
          completion(nil, response.result.error)
          return
        }
        completion(response.result.value as AnyObject?, nil)
    }
  }
  
}
