//
//  ComicTableViewController.swift
//  XKCD-Viewer
//
//  Created by Jon Friskics on 8/23/16.
//  Copyright © 2016 Code School. All rights reserved.
//

import UIKit

class ComicTableViewController: UITableViewController {

    var comics: [Int] = []
    let session = NSURLSession.sharedSession()
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        makeRequest("https://xkcd.com/info.0.json", completionHandler: {(response) in
            let num = response["num"] as! Int
            
            for i in 1...num {
                self.comics.append(i)
            }
            
            self.comics = self.comics.reverse()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }

        })
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ComicCell", forIndexPath: indexPath)

        let comicNum = comics[indexPath.row]
        
        configureCell(cell, comicNum: comicNum)

        return cell
    }
    
    func configureCell(cell: UITableViewCell, comicNum: Int) -> Void {
        cell.textLabel?.text = "\(comicNum)"
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Network Helpers
    
    func makeRequest(urlString: String, completionHandler:([String: AnyObject]) -> ()) -> Void {
        guard let url = NSURL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        session.dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            guard let data = data else {
                print("hmm, some problem happened")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                completionHandler(json)
                
            } catch {
                print("json error: \(error)")
            }
            
            }.resume()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowComic") {
            let comicVC = segue.destinationViewController as? ComicViewController
            
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell) else {
                    return
            }
            
            let comicNum = comics[indexPath.row]

            makeRequest("https://xkcd.com/\(comicNum)/info.0.json") { (response) in
                print(response)
                dispatch_async(dispatch_get_main_queue()) {
                    comicVC?.comic = Comic(jsonData: response)
                }
            }
        }
    }
    
}
