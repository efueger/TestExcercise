//
//  DBHelper.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
  
  func getAllPosts() -> Array<Post> {
    let posts: Array<Post> = []
    let realm = try! Realm()
    let results = realm.objects(Post.self)
    if results.count <= 0 {
      print("error")
      return posts
    }
    else {
      return Array(results)
    }
  }
  
  func getAllCommentsForPostID(postID: Int) -> Array<Comment> {
    let comments: Array<Comment> = []
    let realm = try! Realm()
    let results = realm.objects(Comment.self).filter("postID = \(postID)")
    if results.count <= 0 {
      print("error")
      return comments
    }
    else {
      return Array(results)
    }
  }
  
  func getAuthorForPost(post: Post?) -> Array<User> {
    let users: Array<User> = []
    let realm = try! Realm()
    let results = realm.objects(User.self).filter("id = \(post!.userID)")
    if results.count <= 0 {
      print("error")
      return users
    }
    else {
      return Array(results)
    }
  }
  
  func saveJsonDataRecordsToDB(jsonRecords: [Object]) -> Bool {
    let realm = try! Realm()
   realm.beginWrite()
      for record in jsonRecords {
        realm.add(record, update: true)
      }
    try! realm.commitWrite()
    return true
  }
  
  
}
