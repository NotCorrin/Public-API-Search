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

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var clippedView: UIView!
    
    var entries: [Entries] = Array()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var publicApisList = [publicApis]()
    
    let searchBar = UISearchBar();
    
    override func viewDidLoad() {
        super.viewDidLoad();

        publicApisList = []
        
        for entry in entries {
            let title = entry.API
            let auth = entry.Auth.isEmpty ? "Auth: None" : "Auth: \(entry.Auth)"
            let category = "Category: \(entry.Category)"
            let description = "Description: \(entry.Description)"
            let link = "Link: \(entry.Link)"
            
            let details = [category, auth, description, link]
            
            publicApisList.append(publicApis(title: title, details: details))
        }
        
        configureSearchBarUI()
        configureTableViewUI()
    }
    
    func configureSearchBarUI() {
        view.backgroundColor = .white
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "results.png"), for: .default)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "Results"
        showSearchBarButton(shouldShow: true)
    }
    
    func configureTableViewUI(){
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.frame = view.bounds;
        tableView.backgroundView = UIImageView(image: UIImage(named: "results.png"));
        clippedView.addSubview(tableView);
    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
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
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.lineBreakMode = .byWordWrapping
        }
        return cell;
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        publicApisList[indexPath.section].isOpened = !publicApisList[indexPath.section].isOpened;
        tableView.reloadSections([indexPath.section], with: .none);
    }
}
