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

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var SearchResultsTableView: UITableView!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var publicApisList = [publicApis]()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        publicApisList = [
            publicApis(title: "Title: Liam", details: ["Auth: ", "Category: ", "Link: "].compactMap({ return "\($0)" })),
            publicApis(title: "Christian", details: ["Auth: ", "Category: ", "Link: "].compactMap({ return "\($0)" }))
        ]
        view.addSubview(tableView);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.frame = view.bounds;
        tableView.backgroundView = UIImageView(image: UIImage(named: "results.png"))
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        if indexPath.row == 0 {
            cell.textLabel?.text = publicApisList[indexPath.section].title;
            cell.backgroundColor = UIColor(red: 0.30, green: 0.34, blue: 0.42, alpha: 1.00);
            cell.textLabel?.textColor = UIColor(white: 1, alpha: 1);
        } else {
            cell.textLabel?.text = publicApisList[indexPath.section].details[indexPath.row - 1]
            cell.backgroundColor = UIColor(white: 1, alpha: 1);
            cell.textLabel?.textColor = UIColor(red: 0.30, green: 0.34, blue: 0.42, alpha: 1.00)
        }
        return cell;
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        publicApisList[indexPath.section].isOpened = !publicApisList[indexPath.section].isOpened;
        tableView.reloadSections([indexPath.section], with: .none);
    }
}
