//
//  User.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

public class User: Object {
 
  dynamic var id = 0
  dynamic var name = ""
  dynamic var userName = ""
  dynamic var email = ""
  dynamic var phone = ""
  dynamic var website = ""
  dynamic var companyName = ""
  dynamic var companyPhrase = ""
  dynamic var companyBusiness = ""
  dynamic var streetAddress = ""
  dynamic var suiteAddress = ""
  dynamic var city = ""
  dynamic var zipCode = ""
  dynamic var latitude = ""
  dynamic var longitude = ""
  
  override public static func primaryKey() -> String? {
        return "id"
  }
  
  class func processJsonrecordsToArray(jsonRecords: [[String: AnyObject]]) -> [User] {
    var arrayOfUsers = [User]()
    if jsonRecords.count == 0 {
      return arrayOfUsers
    }
    
    for record in jsonRecords {
      let userAtIndex: User = User()
      let jsonVariable = JSON(record)
      userAtIndex.name = jsonVariable["name"].stringValue
      userAtIndex.userName = jsonVariable["username"].stringValue
      userAtIndex.id = jsonVariable["id"].intValue
      userAtIndex.email = jsonVariable["email"].stringValue
      userAtIndex.phone = jsonVariable["phone"].stringValue
      userAtIndex.website = jsonVariable["website"].stringValue
      userAtIndex.companyName = jsonVariable["company"]["name"].stringValue
      userAtIndex.companyPhrase = jsonVariable["company"]["catchPhrase"].stringValue
      userAtIndex.companyBusiness = jsonVariable["company"]["bs"].stringValue
      userAtIndex.streetAddress = jsonVariable["address"]["street"].stringValue
      userAtIndex.suiteAddress = jsonVariable["address"]["suite"].stringValue
      userAtIndex.city = jsonVariable["address"]["city"].stringValue
      userAtIndex.zipCode = jsonVariable["address"]["zipcode"].stringValue
      userAtIndex.latitude = jsonVariable["address"]["geo"]["lat"].stringValue
      userAtIndex.longitude = jsonVariable["address"]["geo"]["lng"].stringValue
      arrayOfUsers.append(userAtIndex)
    }
    return arrayOfUsers
  }
  
}
