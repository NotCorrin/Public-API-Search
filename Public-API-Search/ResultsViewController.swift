//
//  ResultsViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import UIKit

class publicApis {
    let title: String
    let details: [String]
    var isOpened: Bool = false
    
    init(title: String,
         details: [String],
         isOpened: Bool = false) {
        self.title = title;
        self.details = details;
        self.isOpened = isOpened;
    }
}

class ResultsViewController: UIViewController {

    @IBOutlet weak var SearchResultsTableView: UITableView!
    
    private var publicApisList = [publicApis]()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        publicApisList = [
            publicApis(title: "Liam", details: [1, 2, 3].compactMap({ return "Cell \($0)" })),
            publicApis(title: "Christian", details: [1, 2, 3].compactMap({ return "Cell \($0)" }))
        ]
        SearchResultsTableView.backgroundView = UIImageView(image: UIImage(named: "results.png"))
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return publicApisList.count;
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = publicApisList[section]
        if section.isOpened {
            return section.details.count + 1;
        } else {
            return 1;
        }
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath);
            
            cell.textLabel?.text = publicApisList[indexPath.section].title
            
            return cell;
        }
        return UITableViewCell();
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        tableView.deselectRow(at: indexPath, animated: true);
        publicApisList[indexPath.section].isOpened = !publicApisList[indexPath.section].isOpened;
        tableView.reloadSections([indexPath.section], with: .none);
    }
    
}
