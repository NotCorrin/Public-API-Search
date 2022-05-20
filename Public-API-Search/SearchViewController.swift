//
//  SearchViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    let numberOfButtons = 50
    let buttonHeight = 35
    let buttonWidth = UIScreen.main.bounds.size.width - 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<self.numberOfButtons {
            let frame1 = CGRect(x: 0, y: 0 + (index * buttonHeight), width: Int(buttonWidth), height: buttonHeight )
            let button = UIButton(frame: frame1)
            button.setTitle("asdasd", for: .normal)
            button.setTitleColor(UIColor(red: 236 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1), for: .normal)
            button.backgroundColor = .black
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.categoriesScrollView.addSubview(button)
        }
        
        self.categoriesScrollView.contentSize.height = CGFloat(buttonHeight * numberOfButtons)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("button: \(sender.titleLabel?.text)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}
