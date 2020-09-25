//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Eric Wildey Luttmann on 8/21/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    //initializes to listen to XIB design file
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //change messagebubble layer property to corner radius
        //adjust dynamically based on height of message (height / 5)
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
