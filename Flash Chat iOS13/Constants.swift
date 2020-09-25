//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Eric Wildey Luttmann on 8/17/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

//organized into sub-structs to be more organized

struct K {
    //static turns into 'K' type
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        //Firestore collection
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
