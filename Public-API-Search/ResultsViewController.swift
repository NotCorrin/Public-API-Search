//
//  ResultsViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import UIKit

struct publicApis {
    var title: String
    var auth: String
    var category: String
    var link: String
}

class ResultsViewController: UIViewController {
    
    var publicApiList: [publicApis] = [
        publicApis(title: "Liam", auth: "apiKey", category: "UTS", link: "www.liam.com"),
        publicApis(title: "Christian", auth: "OAuth", category: "UNSW", link: "www.christian.com")
    ]

    @IBOutlet weak var SearchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath);
        let result = publicApiList[indexPath.row];
        
        cell.textLabel?.text = result.title;
        cell.textLabel?.text = result.auth;
        cell.textLabel?.text = result.category;
        cell.textLabel?.text = result.link;
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show top 10 players and their scores
        return publicApiList.count;
    }
}
