//
//  SearchViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import Foundation
import UIKit

struct CategoryData: Decodable {
    let categories: [String]
    let count: Int
}

class SearchViewController: UIViewController {
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesButton: UIButton!
    
    let buttonHeight = 35
    let buttonWidth = UIScreen.main.bounds.size.width - 100
    
    let darkWhite = UIColor(red: 216 / 255, green: 222 / 255, blue: 233 / 255, alpha: 1)
    let darkestBlue = UIColor(red: 46 / 255, green: 52 / 255, blue: 64 / 255, alpha: 1)
    
    let apiBaseURL = "https://api.publicapis.org"
    var categories: [String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
    }
    
    @IBAction func categoriesButtonOnClick(_ sender: Any) {
        categoriesScrollView.backgroundColor = darkWhite
        
        for index in 0..<self.categories.count {
            let frame1 = CGRect(x: 0, y: 0 + (index * buttonHeight), width: Int(buttonWidth), height: buttonHeight )
            let button = UIButton(frame: frame1)
            button.setTitle("\(categories[index])", for: .normal)
            button.setTitleColor(darkestBlue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.categoriesScrollView.addSubview(button)
        }
        
        self.categoriesScrollView.contentSize.height = CGFloat(buttonHeight * categories.count)
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
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    func fetchCategories() {
        let urlString = "\(apiBaseURL)/categories"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("ERROR")
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    self.parseJSON(categoryData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(categoryData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CategoryData.self, from: categoryData)
            print(decodedData.categories)
            print(decodedData.count)
            categories = decodedData.categories
        } catch {
            print("ERROR in parseJSON()")
        }
    }
}
