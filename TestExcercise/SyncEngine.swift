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
    networkManager.downloadRequestForClass(className: "Post", completion: {[weak self] (value, error) in
      guard let responseJson = value else {
        print(error)
        self?.handleError(error: error!)
        return
      }
      if let parsedResponse = self?.processResponseFromServer(response: responseJson) {
        let posts = Post.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self?.dbManager.saveJsonDataRecordsToDB(jsonRecords: posts, success: {
          self?.downloadDataForComments()
          }, fail: { (error) in
            print ("post Sync unsuccessful with error: \(error.localizedDescription)") // implement the code to retry After sometime
            self?.willChangeValue(forKey: "isSyncInProgress")
            self?.isSyncInProgress = false
            self?.didChangeValue(forKey: "isSyncInProgress")
        })
      }
      })
  }
  
  func downloadDataForComments() -> Void {
    networkManager.downloadRequestForClass(className: "Comment", completion: {[weak self] (value, error) in
      guard let responseJson = value else {
        print(error)
        self?.handleError(error: error!)
        return
      }
      if let parsedResponse = self?.processResponseFromServer(response: responseJson) {
        let comments = Comment.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self!.dbManager.saveJsonDataRecordsToDB(jsonRecords: comments, success: {
          self?.downloadDataForUsers()
          }, fail: { (error) in
            print ("comment Sync unsuccessful with error: \(error.localizedDescription)") // implement the code to retry After sometime
            self?.willChangeValue(forKey: "isSyncInProgress")
            self?.isSyncInProgress = false
            self?.didChangeValue(forKey: "isSyncInProgress")
        })
      }
      })
  }
  
  func downloadDataForUsers() -> Void {
    networkManager.downloadRequestForClass(className: "User", completion: {[weak self] (value, error) in
      guard let responseJson = value else {
        print(error)
        self?.handleError(error: error!)
        return
      }
      if let parsedResponse = self?.processResponseFromServer(response: responseJson) {
        let users = User.processJsonrecordsToArray(jsonRecords: parsedResponse)
        self!.dbManager.saveJsonDataRecordsToDB(jsonRecords: users,success: {
          self?.executeSyncCompletedSuccessfully()
          }, fail: { (error) in
            print ("User Sync unsuccessful with error: \(error.localizedDescription)") // implement the code to retry After sometime
            self?.willChangeValue(forKey: "isSyncInProgress")
            self?.isSyncInProgress = false
            self?.didChangeValue(forKey: "isSyncInProgress")
        })
      }
      })
  }
  
  func processResponseFromServer(response: Any) -> [[String: AnyObject]]? {
    guard let initialJsonObject = JSON(response).arrayObject, let arrayParsedFromJson = initialJsonObject as? [[String: AnyObject]] else {
      print("Malformed data")
      return  nil
    }
    return arrayParsedFromJson
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
