//
//  Post.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.


import Foundation
import RealmSwift
import SwiftyJSON

public class Post: Object {
  dynamic var id = 0
  dynamic var userID = 0
  dynamic var title = ""
  dynamic var body = ""
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  class func processJsonrecordsToArray(jsonRecords: [[String: AnyObject]]) -> [Post] {
    var arrayOfPosts = [Post]()
    if jsonRecords.count == 0 {
      return arrayOfPosts
    }
    
    for record in jsonRecords {
      let postAtIndex = Post()
      let jsonVariable = JSON(record)
      postAtIndex.title = jsonVariable["title"].stringValue
      postAtIndex.userID = jsonVariable["userId"].intValue
      postAtIndex.id = jsonVariable["id"].intValue
      postAtIndex.body = jsonVariable["body"].stringValue
      arrayOfPosts.append(postAtIndex)
    }
    return arrayOfPosts
  }
  
}
