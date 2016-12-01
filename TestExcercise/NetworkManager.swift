//
//  HTTPClient.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class NetworkManager {
  
  let baseUrl = "http://jsonplaceholder.typicode.com/"
  
  func downloadRequestForClass(className: String) -> Promise<AnyObject> {
    let url = baseUrl + className.appending("s")
    
    return Promise { fulfill, reject in
      Alamofire.request(url).validate()
        .responseJSON { (response) -> Void in
          guard response.result.isSuccess else {
            reject(response.result.error!)
            return
          }
          fulfill(response.result.value as AnyObject)
      }
    }
  }
  
  /*
   func myThingy() -> Promise<AnyObject> {
   return Promise{ fulfill, reject in
   Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"]).response { (_, _, data, error) in
   if error == nil {
   fulfill(data)
   } else {
   reject(error)
   }
   }
   }
   }
   
   */
  
}
