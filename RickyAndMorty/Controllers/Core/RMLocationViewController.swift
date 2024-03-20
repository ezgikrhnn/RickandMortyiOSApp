//
//  RMLocationViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

import UIKit

final class RMLocationViewController: UIViewController {

    private let primaryView = RMLocationView()
   
    private let viewModel = RMLocationViewViewModel()
    
    //MARK: -Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView) //RMLoactionView nesnesini burada ekledim.
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addConstraints()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapShare))
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    
    @objc
    private func didTapShare(){
        
    }


}
