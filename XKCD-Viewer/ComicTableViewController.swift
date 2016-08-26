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
    let session = URLSession.shared
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeRequest("https://xkcd.com/info.0.json", completionHandler: {(response) in
            let num = response["num"] as! Int
            
            for i in 1...num {
                self.comics.append(i)
            }
            
            self.comics = self.comics.reversed()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCell", for: indexPath)

        let comicNum = comics[indexPath.row]
        
        configureCell(cell, comicNum: comicNum)

        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, comicNum: Int) -> Void {
        cell.textLabel?.text = "\(comicNum)"
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Network Helpers
    
    func makeRequest(_ urlString: String, completionHandler:@escaping ([String: AnyObject]) -> ()) -> Void {
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            guard let data = data else {
                print("hmm, some problem happened")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                completionHandler(json)
                
            } catch {
                print("json error: \(error)")
            }
            
            }.resume()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowComic") {
            let comicVC = segue.destination as? ComicViewController
            
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                    return
            }
            
            let comicNum = comics[indexPath.row]

            makeRequest("https://xkcd.com/\(comicNum)/info.0.json") { (response) in
                print(response)
                DispatchQueue.main.async {
                    comicVC?.comic = Comic(jsonData: response)
                }
            }
        }
    }
    
}
