//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    //outlet from tableView in storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //reference to Firestore database
    let db = Firestore.firestore()
    
    //Deleted the initial hard-coded messages
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign TableView to look to ChatViewController (self) to trigger delegate method & get data
        tableView.dataSource = self
        
        //add title to navigation bar - from constant 'K'
        title = K.appName
        
        //hides back button from nav controller
        navigationItem.hidesBackButton = true
        
        //register Xib
        //Initialize with Nib - use Nib name (name of file) via constant (which is same as Xib file name), bundle is nil, forCellReuseIdentifier - use constant for identifier
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //call function to retrieve message data from db
        loadMessages()
        
    }
    
    //show messages from Firebase in UI
    func loadMessages() {
        
        //tap into FireBase database collection, then order based on "date" field in db, then use addSnapShotListener to find documents & then listen for updates
        //will return QuerySnapShot & error
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (QuerySnapshot, error) in
            
            //clear local message array each time so only show 1 version of each document when re-loaded (no duplicates added)
            self.messages = []
            
            if let e = error {
                print("Issue retrieiving message data \(e)")
            } else {
                //create constant 'snapshotDocuments' array, unwrap by tapping into querySnapshot documents
                //* querySnapshot = array of documents in collection
                if let snapshotDocuments = QuerySnapshot?.documents {
                
                    //loop through array of all documents, tap into data property (of type dictionary) for each document
                    for doc in snapshotDocuments {
                    //⭐️ In FB, access data from each doc then save as local 'data' object (data is key value pair)
                       let data = doc.data()
                        //break up data into sender & body value (access w/ [] b/c dictionary)
                        //use optional bind to check for sender and body value (optionals)
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            
                            //create newMessage object that will add to array of messages. (create from data in db in format of Message struct). For sender & body property use value from 'data' from Firebase
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            
                            //add newMessage to array
                            //inside closure (getDocuments), so add self
                            self.messages.append(newMessage)
                            
                            //tap into table view & trigger numberrows & indexpath again
                            //use DispatchQueue to drive reload to main thread to show on UI, rather than background in closure
                            DispatchQueue.main.async {
                                //self b/c in closure
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                            
                    }
                }
            }
        }
    }
    
    //user presses send
    @IBAction func sendPressed(_ sender: UIButton) {

        //create constant to hold message = whatever user has entered into text field
        //grab the text when user presses button
        
        //grab hold of logged in user's email address
        //tap into current user Firebase on local, then go layer deeper into email address
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            
            //Send message data to Firebase
            //create collection, "messages", then tap into
            //Craete new rows in db via function "addDocument"
            //data to send will be dictionary (key, value pair) - value = Any datatype
            db.collection(K.FStore.collectionName).addDocument(data: [
                // ^ this will create new rows in Firebase database, code below determines scope & format to print
                //send the user info to FB (key = sender, value = messageSender)
                K.FStore.senderField : messageSender,
                //key = body, value = messageBody
                K.FStore.bodyField : messageBody,
                //add timestamp to each document (key = "date", value = seconds since 19270)
                K.FStore.dateField: Date().timeIntervalSince1970
                
            //completion handler for error or success
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            //sign out user via Firebase
            try firebaseAuth.signOut()
            //send back to welcome screen (root VC)
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}

//allows table view to make request for data when loads
extension ChatViewController: UITableViewDataSource {
    
    //controls # of rows in table view
    //returns an integer to create # of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //count # of messages in "messages" array
        return messages.count
    }
    
    //connect cell to show in tableview
    //indexPath = position of current row.
    //this function's purpose is to display content in each cell. It gets called for each row / cell in table view, then pulls data for each row. numberOfRows above dictates # times function runs based on messages.count
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a cell - use identifier from resusable cell added in Storyboard
        //this returns reusable cell object - adds to table
        //cast cell as type MessageCell
        
        //set equal to current message from array
        let message = messages[indexPath.row]
        
        /* Create & Add message to cell --> */
        //create message cell using messageCell clase + messageCell Xib
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        //give cell data from current row in messages array
        //tap into label outlet on MessageCell
        cell.label.text = message.body
        
        /* Adjustsments to cell --> */
        //if message from current user
        //...Control cell displayed if sender property of message row in db matches current logged in user
        //doing reverse of how we assigned sender property as user email
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            //show the right image view
            cell.rightImageView.isHidden = false
            //messageBubble = UIView geometry in cell
            //use constant to pinpoint string which associates to custom color in assets
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            //label is text over messagebubble
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        //If message is from another user
        //do opposite design as current user
        else{
            //show the left imageview
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        //returns the cell to send to UI
        return cell
    }
}

//when Table view interacted with user
extension ChatViewController: UITableViewDelegate {
    // when row is selected - trigger function b/c set ChatVC as delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}

