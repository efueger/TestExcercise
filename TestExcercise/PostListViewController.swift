//
//  ViewController.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 26/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var table: UITableView!
  
  let apiHelperInstance = APIHelper.sharedInstance
  var postLists: Array? = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.table.dataSource = self
    self.table.delegate = self
    self.loadPosts()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(self.loadPosts), name: .dbSyncCompleted, object: nil)
    SyncEngine.sharedInstance.addObserver(self, forKeyPath: "isSyncInProgress", options: .new, context: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: .dbSyncCompleted, object: nil)
    SyncEngine.sharedInstance.removeObserver(self, forKeyPath: "isSyncInProgress")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func loadPosts() {
    apiHelperInstance.getAllPosts(completion: {[weak self] (posts, error) in
      if error != nil {
        self?.executeUnreachableNetworkAndNoRecordsCase()
      }else {
        self?.postLists = posts
        self?.table.reloadData()
      }
      self?.table.isHidden = posts.count == 0 ? true : false
      })
  }
  
  func executeUnreachableNetworkAndNoRecordsCase() {
    let alert = UIAlertController(title: "", message: "There are no post to show. Please try again!", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.navigationController?.present(alert, animated: true, completion: nil)
  }

  func checkStatus() {
    if SyncEngine.sharedInstance.isSyncInProgress {
      self.activityIndicator.startAnimating()
    }else {
      self.activityIndicator.stopAnimating()
    }
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
      let destinationNavigationController = segue.destination as! PostDetailViewController
      destinationNavigationController.post = selectedPost
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "isSyncInProgress" {
      self.checkStatus()
    }
  }
  
}
