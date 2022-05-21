//
//  SearchViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import Foundation
import UIKit

enum SearchType {
case categories
case entries
}

struct CategoryData: Decodable {
    let categories: [String]
    let count: Int
}

struct EntriesData: Decodable {
    let count: Int
    let entries: [Entries]
}

struct Entries: Decodable {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}

class SearchViewController: UIViewController {
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var authSwitch: UISwitch!
    
    let buttonHeight = 35
    let buttonWidth = UIScreen.main.bounds.size.width - 100
    
    let darkWhite = UIColor(red: 216 / 255, green: 222 / 255, blue: 233 / 255, alpha: 1)
    let darkestBlue = UIColor(red: 46 / 255, green: 52 / 255, blue: 64 / 255, alpha: 1)
    
    let apiBaseURL = "https://api.publicapis.org"
    var categories: [String] = Array()
    var entries: [Entries] = Array()
    
    var hasCategoriesLoaded = false
    var hasDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch(query: "categories", searchType: SearchType.categories)
    }
    
    func waitForLoad() {
        var counter = 60.0
        var _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            timer in
            counter -= 0.1
            
            if (self.hasDataLoaded) {
                timer.invalidate()
                self.loadResultsViewController()
            }
            
            if (counter == 0) {
                timer.invalidate()
                print("ERROR")
            }
        }
    }
    
    func loadResultsViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        
        vc.entries = self.entries
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toResults") {
            let _ = segue.destination as! ResultsViewController
        }
    }
    
    @IBAction func categoriesButtonOnClick(_ sender: Any) {
        if (!hasCategoriesLoaded) {
            categoriesScrollView.backgroundColor = darkWhite
            
            for index in 0..<self.categories.count + 1 {
                let frame1 = CGRect(x: 0, y: 0 + (index * buttonHeight), width: Int(buttonWidth), height: buttonHeight )
                let button = UIButton(frame: frame1)
                if (index == 0) {
                    button.setTitle("Categories", for: .normal)
                } else {
                    button.setTitle("\(categories[index - 1])", for: .normal)
                }
                button.setTitleColor(darkestBlue, for: .normal)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                self.categoriesScrollView.addSubview(button)
            }
            self.categoriesScrollView.contentSize.height = CGFloat(buttonHeight * (categories.count + 1))
            hasCategoriesLoaded = true
        }
        toggleDropdown()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        categoriesButton.setTitle(sender.currentTitle, for: .normal)
        toggleDropdown()
    }
    
    func toggleDropdown() {
        UIView.animate(withDuration: 0.35) {
            self.categoriesScrollView.isHidden = !self.categoriesScrollView.isHidden
        }
    }
    
    @IBAction func randomButtonOnClick(_ sender: Any) {
        hasDataLoaded = false
        performFetch(query: "random", searchType: SearchType.entries)
        waitForLoad()
    }
    
    @IBAction func searchButtonOnClick(_ sender: Any) {
        hasDataLoaded = false
        
        let titleParam = searchTextField.hasText ? "title=" + searchTextField.text! : ""
        var categoryParam = categoriesButton.titleLabel!.text == "Categories" ? "" : "category=" + (categoriesButton.titleLabel?.text)!
        let auth: String = authSwitch.isOn ? "a" : "null"
        
        let firstSep = titleParam.isEmpty ? "" : "&"
        let secondSep = categoryParam.isEmpty ? "" : "&"
        
        if (categoryParam.contains(" ")) {
            categoryParam = categoryParam.components(separatedBy: " ").first!
        }
        
        let query = "entries?\(titleParam)\(firstSep)\(categoryParam)\(secondSep)auth=\(auth)"
        
        performFetch(query: query, searchType: SearchType.entries)
        waitForLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    func performFetch(query: String, searchType: SearchType) {
        if let url = URL(string: "\(apiBaseURL)/\(query)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("ERROR")
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        switch searchType {
                        case .categories:
                            let decodedData = try decoder.decode(CategoryData.self, from: safeData)
                            self.categories = decodedData.categories
                        case .entries:
                            let decodedData = try decoder.decode(EntriesData.self, from: safeData)
                            self.entries = decodedData.entries
                            self.hasDataLoaded = true
                        }
                    } catch {
                        print("ERROR in parseJSON()")
                    }
                }
            }
            task.resume()
        }
    }
}
