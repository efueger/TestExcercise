//
//  APIHelper.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation


class APIHelper {
  
  private let dbManager: DBManager
  
  init() {
    dbManager = DBManager()
  }
  
  static let sharedInstance: APIHelper = {
    let instance = APIHelper()
    return instance
  }()
  
  func getAllPosts(completion: (_ postList: [Post], _ error: Error?) -> Void) -> Void {
    let posts: [Post] = dbManager.getAllPosts()
    if posts.count == 0 && SyncEngine.sharedInstance.syncError != nil {
       completion(posts, SyncEngine.sharedInstance.syncError)
    }else {
      completion(posts, nil)
    }
  }
  
  func getAllCommentsForPostID(postID: Int) -> [Comment] {
    let comments: [Comment] = dbManager.getAllCommentsForPostID(postID: postID)
    return comments
  }
  
  func getAuthorForPost(post: Post?) -> User {
    let users: [User] = dbManager.getAuthorForPost(post: post)
    if users.count > 0 {
      return users[0]
    } else {
      let user: User = User()
      return user
    }
  }
  
}
