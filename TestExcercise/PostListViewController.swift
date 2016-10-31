//
//  ViewController.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var table: UITableView!
  
  let apiHelperInstance = APIHelper.sharedInstance
  var postLists: Array? = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateControllerWithPosts()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateControllerWithPosts), name: .dbSyncCompleted, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: .dbSyncCompleted, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func loadPosts() {
    apiHelperInstance.getAllPosts(completion: {[weak self] posts in
      self?.postLists = posts
      self?.updateViewWithPosts()
      })
  }
  
  func updateViewWithPosts() {
    if (self.postLists?.count)! == 0 && !ReachabilityManager.sharedInstance.isNetworkReachable {
      self.executeUnreachableNetworkAndNoRecordsCase()
    } else {
      self.table.dataSource = self
      self.table.delegate = self
      self.table.isHidden = false
      self.table.reloadData()
      self.activityIndicator.stopAnimating()
    }
  }
  
  func executeUnreachableNetworkAndNoRecordsCase() {
    let alert = UIAlertController(title: "", message: "There are no post to show. Please try again!", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.navigationController?.present(alert, animated: true, completion: nil)
    self.table.isHidden = true
  }
  
  func updateControllerWithPosts() {
    self.view.bringSubview(toFront: self.activityIndicator)
    self.activityIndicator.startAnimating()
    self.perform(#selector(loadPosts), with: nil, afterDelay: 0.1) // Putting this delay to give time to Reachability to respond.
  }
  
  // Mark Table View
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let posts = self.postLists else {
      return 0
    }
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
    guard let newPostList = self.postLists else {
      print("PostList is Empty")
      return cell
    }
    if let post = newPostList[indexPath.row] as? Post {
      cell.textLabel?.text = post.title
    }
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let path = table.indexPath(for: (sender as? UITableViewCell)!) {
      guard let selectedPost = self.postLists?[path.row] as? Post else {
        print("show alert post not detected")
        return
      }
      let destinationNavigationController = segue.destination as! UINavigationController
      (destinationNavigationController.topViewController as? PostDetailViewController)?.post = selectedPost
    }
  }
  
}
