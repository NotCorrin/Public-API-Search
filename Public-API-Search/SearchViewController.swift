//
//  SearchViewController.swift
//  Public-API-Search
//
//  Created by Mateen Mahmood on 20/5/2022.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesButton: UIButton!
    
    let numberOfButtons = 50
    let buttonHeight = 35
    let buttonWidth = UIScreen.main.bounds.size.width - 100
    
    let darkWhite = UIColor(red: 216 / 255, green: 222 / 255, blue: 233 / 255, alpha: 1)
    let darkestBlue = UIColor(red: 46 / 255, green: 52 / 255, blue: 64 / 255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesScrollView.backgroundColor = darkWhite
        
        for index in 0..<self.numberOfButtons {
            let frame1 = CGRect(x: 0, y: 0 + (index * buttonHeight), width: Int(buttonWidth), height: buttonHeight )
            let button = UIButton(frame: frame1)
            button.setTitle("asdasd", for: .normal)
            button.setTitleColor(darkestBlue, for: .normal)
//            button.backgroundColor = .black
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.categoriesScrollView.addSubview(button)
        }
        
        self.categoriesScrollView.contentSize.height = CGFloat(buttonHeight * numberOfButtons)
    }
    
    @IBAction func categoriesButtonOnClick(_ sender: Any) {
        UIView.animate(withDuration: 0.35) {
            self.categoriesScrollView.isHidden = !self.categoriesScrollView.isHidden
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
//        print("button: \(sender.titleLabel?.text)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}
