//
//  CommentTableViewCell.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 27/10/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
  @IBOutlet weak var lblComment: UILabel!
  @IBOutlet weak var lblName: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
