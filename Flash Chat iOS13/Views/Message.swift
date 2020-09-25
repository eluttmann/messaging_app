//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Eric Wildey Luttmann on 8/18/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

//represents the model & format for messages
struct Message {
    //email address of who sent message (ericluttmann3@gmail.com)
    let sender: String
    //contain the body of the message
    let body: String
}
