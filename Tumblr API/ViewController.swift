//
//  ViewController.swift
//  Tumblr API
//
//  Created by Joey Singer on 2/7/17.
//  Copyright © 2017 Joey Singer. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var photoCell: PhotoCell!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var posterView: UIImageView!
    
    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        task.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoCell
        //cell.textLabel?.text = "This is row \(indexPath.row)"
        let post = posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.posterView.setImageWith(imageUrl)
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            

            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        return cell
    }
    
    

}

