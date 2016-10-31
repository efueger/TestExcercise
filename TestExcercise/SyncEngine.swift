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

final class SyncEngine: NSObject {
  
  let initialSyncCompletedKey = "IntialSyncCompleted"
  var isSyncInProgress: Bool = false
  var isPostSynchSuccessful: Bool = false
  var isUSerSynchSuccessful: Bool = false
  var isCommentSynchSuccessful: Bool = false
  
  private let dbManager: DBManager
  private let networkManager: NetworkManager
  
  static let sharedInstance: SyncEngine = {
    let instance = SyncEngine()
    
    return instance
  }()
  
  private override init() {
    
    dbManager = DBManager()
    networkManager = NetworkManager()
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
      DispatchQueue.global(qos: .background).async {
        self.downloadDataForObjects(useUpadatedAtDate: false)
      }
    }
  
  func executeSyncCompletedOperation() -> Void {
    DispatchQueue.main.async {
      self.setInitialSyncCompleted()
      NotificationCenter.default.post(name: .dbSyncCompleted, object: nil)
      self.willChangeValue(forKey: "isSyncInProgress")
      self.isSyncInProgress = false
      self.didChangeValue(forKey: "isSyncInProgress")
    }
  }
  
  func downloadDataForObjects(useUpadatedAtDate useUpdatedAtDate: Bool) -> Void {
    networkManager.downloadRequestForClass(className: "Posts", completion: {[weak self] value in
      if let parsedResponse = self?.processResponseFromServer(response: value) {
        let posts = Post.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self?.isPostSynchSuccessful = (self?.dbManager.saveJsonDataRecordsToDB(jsonRecords: posts))!
        if !(self?.isPostSynchSuccessful)! {
          print ("post Sync unsuccessful") // implement the code to retry After sometime
        }
        self?.downloadDataForComments()
      }
      })
  }
  
  func downloadDataForComments() -> Void {
    networkManager.downloadRequestForClass(className: "Comments", completion: {[weak self] value in
      if let parsedResponse = self?.processResponseFromServer(response: value) {
        let comments = Comment.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self?.isCommentSynchSuccessful =  self!.dbManager.saveJsonDataRecordsToDB(jsonRecords: comments)
        if !(self?.isCommentSynchSuccessful)! {
          print ("comments Sync unsuccessful") // implement the code to retry After sometime
        }
        self?.downloadDataForUsers()
      }
      })
  }
  
  func downloadDataForUsers() -> Void {
    networkManager.downloadRequestForClass(className: "Users", completion: {[weak self] value in
      if let parsedResponse = self?.processResponseFromServer(response: value) {
        let users = User.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self?.isUSerSynchSuccessful =  self!.dbManager.saveJsonDataRecordsToDB(jsonRecords: users)
        if !(self?.isUSerSynchSuccessful)! {
          print ("User Sync unsuccessful") // implement the code to retry After sometime
        }
        self?.executeSyncCompletedOperation()
      }
      })
  }
  
  func processResponseFromServer(response: Any) -> [[String: AnyObject]]? {
    guard let initialJsonObject = JSON(response).arrayObject, let arrayParsedFromJson = initialJsonObject as? [[String: AnyObject]] else {
      print("Malformed data")
      self.executeSyncCompletedOperation()
      return  nil
    }
    return arrayParsedFromJson
  }
  
}
