//
//  RMLocationViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

import UIKit

final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapShare))
    }
    
    @objc
    private func didTapShare(){
        
    }


}
