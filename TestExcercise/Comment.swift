//
//  Comment.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

public class Comment: Object {
  
  dynamic var id = 0
  dynamic var name = ""
  dynamic var postID = 0
  dynamic var email = ""
  dynamic var body = ""
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  class func processJsonrecordsToArray(jsonRecords: [[String: AnyObject]]) -> [Comment] {
    var arrayOfComments = [Comment]()
    if jsonRecords.count == 0 {
      return arrayOfComments
  }
    
    for record in jsonRecords {
      let commentAtIndex: Comment = Comment()
      let jsonVariable = JSON(record)
      commentAtIndex.name = jsonVariable["name"].stringValue
      commentAtIndex.postID = jsonVariable["postId"].intValue
      commentAtIndex.id = jsonVariable["id"].intValue
      commentAtIndex.email = jsonVariable["email"].stringValue
      commentAtIndex.body = jsonVariable["body"].stringValue
      arrayOfComments.append(commentAtIndex)
    }
    return arrayOfComments
  }
  
}
