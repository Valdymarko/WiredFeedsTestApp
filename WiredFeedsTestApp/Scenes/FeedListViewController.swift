//
//  FeedListViewController.swift
//  WiredFeedsTestApp
//
//  Created by Володимир Ільків on 1/12/19.
//  Copyright © 2019 Володимр Ільків. All rights reserved.
//

import UIKit

class FeedListViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var rssItems : [RSSItem]?
    
    //MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    //MARK: - IBActions

    @IBAction private func refreshAction(_ sender: Any) {
        fetchData()
    }
    
    private func fetchData(){
        let xmlParserManager = XmlParserManager()
        xmlParserManager.parseFeed(url: "https://www.wired.com/feed/rss") { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .top)
            }
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsTableViewCell", for: indexPath) as! FeedsTableViewCell
        if let item = rssItems?[indexPath.item]{
            cell.item = item
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlString = rssItems?[indexPath.item].link
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

