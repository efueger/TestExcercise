//
//  PostDetailViewController.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 27/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var post: Post!
  var commentLists: Array? = []
  var postAuthor: User?
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var lblAuthorOfPost: UILabel!
  @IBOutlet weak var lblPostDescription: UILabel!  
  @IBOutlet weak var lblPostTitle: UILabel!
  @IBOutlet weak var lblCommentsTitle: UILabel!
  
   override func viewDidLoad() {
    super.viewDidLoad()
    self.commentLists = APIHelper.sharedInstance.getAllCommentsForPostID(postID: post.id)
    self.postAuthor = APIHelper.sharedInstance.getAuthorForPost(post: post)
    guard let postOwner = self.postAuthor else {
      print("error in getting the author")
      return
    }
    lblAuthorOfPost.text = "by " + postOwner.name
    lblPostDescription.text = self.post.body
    lblPostTitle.text = self.post.title
    self.configureTable()
  }
  
  func configureTable() {
    table.estimatedRowHeight = 44.0
    table.rowHeight = UITableViewAutomaticDimension
    if commentLists?.count == 0 {
      table.isHidden = true
      lblCommentsTitle.isHidden = true
    }else {
      table.isHidden = false
      lblCommentsTitle.isHidden = false
      lblCommentsTitle.text = "Comments(\((commentLists?.count)!))"
    }
    self.table.allowsSelection = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    table.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // Mark Table View
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let comment = self.commentLists else{
      return 0
    }
    return comment.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
      return tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
    }
    guard let newCommentList = self.commentLists else {
      print("comment list is Empty")
      return cell
    }
    if let comment = newCommentList[indexPath.row] as? Comment {
      cell.lblComment.text = comment.body
      cell.lblName.text = comment.name
    }
    return cell
  }
  
}
