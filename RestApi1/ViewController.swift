//
//  ViewController.swift
//  RestApi1
//
//  Created by Vidya Ramamurthy on 13/01/16.
//  Copyright © 2016 BridgeLabz. All rights reserved.
//
// First Commit

// This is Local changes which will be push on branch Komal
// changed Local1
// This line added on GitHub in branch Komal
//Ned


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ipLabel: UILabel!
    
    @IBOutlet weak var postResultLabel: UILabel!
    
    @IBOutlet weak var bodyLable: UILabel!
    
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLable: UILabel!
    
    @IBOutlet weak var serachIDTextField: UITextField!
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
         updateIP()
        
        
    }
    
    //MARK: - viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call our two REST services
        //updateIP()
        postDataToURL()
    }
    
    
    //MARK: - REST calls
    // This makes the GET call to httpbin.org. It simply gets the IP address and displays it on the screen.
    func updateIP() {
        
        
        
        let postEndpoint: String =  "http://jsonplaceholder.typicode.com/todos"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print("IP string",ipString)
                    
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                                        // Update the label
                    self.performSelectorOnMainThread("updateIPLabel:", withObject: jsonDictionary, waitUntilDone: false)
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
        
          }
    
    
    func postDataToURL() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://jsonplaceholder.typicode.com/posts"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["hello": "Hello POST world"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
        
        
           }
    
  
    func updateIPLabel(diction: NSArray) {
        let searchDetails: Int?
            
        searchDetails = Int(serachIDTextField.text!)
        print("ID DETAIL",(searchDetails)!)
        let titleArray = diction[(searchDetails)!-1] as! NSDictionary
        let title = titleArray["title"] as! String
       
        let userId = titleArray["userId"] as! Int
        let id = titleArray["id"] as! Int
        let completed = titleArray["completed"] as! Bool
       
        //self.bodyLable.text = body
         self.ipLabel.text = " " + title
        self.userIdLable.text = String(format : "%d",userId)
        self.idLabel.text = String(format : "%d",id)
        if completed
        {
        self.bodyLable.text = "true"
        }
        else
        {
            self.bodyLable.text = "false"
 
        }
        
    }
    //
    func updatePostLabel(text: String) {
        self.postResultLabel.text = "POST : " + text
    }


}

