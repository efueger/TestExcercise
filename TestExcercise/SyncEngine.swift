//
//  SyncEngine.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift
import PromiseKit

enum MyError : Error {
  case CustomError(String)
}

final class SyncEngine: NSObject {
  
  let initialSyncCompletedKey = "IntialSyncCompleted"
  var isSyncInProgress: Bool = false
  var isPostSynchSuccessful: Bool = false
  var isUSerSynchSuccessful: Bool = false
  var isCommentSynchSuccessful: Bool = false
  var syncError: Error?
  var registeredClassesToSync = [String]()
  var moduleName = "TestExcercise."
  
  private let dbManager: DBManager
  private let networkManager: NetworkManager
  
  static let sharedInstance: SyncEngine = {
    let instance = SyncEngine()
    
    return instance
  }()
  
  private override init() {
    
    dbManager = DBManager()
    networkManager = NetworkManager()
    registeredClassesToSync.append(Post.className())
    registeredClassesToSync.append(Comment.className())
    registeredClassesToSync.append(User.className())
    
    super.init()
    ReachabilityManager.sharedInstance.startReachabilityObserver()
    NotificationCenter.default.addObserver(self, selector: #selector(executeNetworkbecomesReachableOperations), name: .networkIsReachable, object: nil)
  }
  
  func executeNetworkbecomesReachableOperations() {
    self.startSync()
  }
  
  func initialSyncComplete() -> Bool {
    return (Bool)(UserDefaults.standard.value(forKey: initialSyncCompletedKey) != nil)
  }
  
  func setInitialSyncCompleted() {
    UserDefaults.standard.set(Int(true), forKey: initialSyncCompletedKey)
    UserDefaults.standard.synchronize()
  }
  
  func startSync() {
    if isSyncInProgress {
      return
    }
    self.willChangeValue(forKey: "isSyncInProgress")
    isSyncInProgress = true
    self.didChangeValue(forKey: "isSyncInProgress")
    self.willChangeValue(forKey: "syncError")
    self.syncError = nil
    self.didChangeValue(forKey: "syncError")
    DispatchQueue.global(qos: .background).async {
      self.downloadDataForObjects(useUpadatedAtDate: false)
    }
  }
  
  func executeSyncCompletedSuccessfully() -> Void {
    DispatchQueue.main.async {
      self.setInitialSyncCompleted()
      self.willChangeValue(forKey: "isSyncInProgress")
      self.isSyncInProgress = false
      self.didChangeValue(forKey: "isSyncInProgress")
      NotificationCenter.default.post(name: .dbSyncCompleted, object: nil)
      self.syncError = nil
    }
  }
  
  func downloadDataForObjects(useUpadatedAtDate useUpdatedAtDate: Bool) -> Void {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
      let postDownloadPromise = self.networkManager.downloadRequestForClass(className: "Post")
      let commentDownloadPromise = self.networkManager.downloadRequestForClass(className: "Comment")
      let userDownloadPromise = self.networkManager.downloadRequestForClass(className: "User")
      let promises = [postDownloadPromise, commentDownloadPromise, userDownloadPromise]
     when(fulfilled: promises).then { results -> Void  in
        let postParsedResponsePromise = self.processResponseFromServer(response: results[0])
        let commentParsedResponsePromise = self.processResponseFromServer(response: results[1])
        let userParsedResponsePromise = self.processResponseFromServer(response: results[2])
        let promises = [postParsedResponsePromise, commentParsedResponsePromise, userParsedResponsePromise]
      
        when(fulfilled: promises).then(execute: { (responses: [[[String : AnyObject]]]) -> Void in
          let posts = Post.processJsonrecordsToArray(jsonRecords: responses[0])
          let comments = Comment.processJsonrecordsToArray(jsonRecords: responses[1])
          let users = User.processJsonrecordsToArray(jsonRecords: responses[2])
          
          let postsSavedPromise = self.dbManager.saveJsonDataRecordsToDB(jsonRecords: posts)
          let commentsSavedPromise = self.dbManager.saveJsonDataRecordsToDB(jsonRecords: comments)
          let usersSavedPromise = self.dbManager.saveJsonDataRecordsToDB(jsonRecords: users)
          let promises = [postsSavedPromise, commentsSavedPromise, usersSavedPromise]
          
          when(fulfilled: promises).then(execute: { (response: [AnyObject]) -> Void in
            self.executeSyncCompletedSuccessfully()
          })
         })
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }.catch { error in
        self.handleError(error: error)
    }
  }

func processResponseFromServer(response: Any) -> Promise<[[String: AnyObject]]> {
  return Promise { fulfill, reject in
    guard let initialJsonObject = JSON(response).arrayObject, let arrayParsedFromJson = initialJsonObject as? [[String: AnyObject]] else {
      reject (MyError.CustomError("Malformed data"))
      return
    }
    fulfill(arrayParsedFromJson)
  }
}

func handleError(error: Error) {
  if (error as NSError).code == -1009  && self.initialSyncComplete() == false {
    DispatchQueue.main.async {
      self.willChangeValue(forKey: "isSyncInProgress")
      self.isSyncInProgress = false
      self.didChangeValue(forKey: "isSyncInProgress")
      self.syncError = error
      NotificationCenter.default.post(name: .dbSyncCompleted, object: nil)
    }
  }
}

}
