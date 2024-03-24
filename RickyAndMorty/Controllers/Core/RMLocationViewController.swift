//
//  RMLocationViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

/*
 Viewmodel.delegate = self  --> bu işlem sayesinde viewmodeldeki işlemler tamamlandığında viewmodel bu durumu controllera bildirebilir. Yani, viewModel'in içinde delegate?.didFetchInitialLocations() gibi bir çağrı yapıldığında, aslında RMLocationViewController'ın didFetchInitialLocations() metodu tetiklenir.
 
 view'e viewModel'ı configuration ile bağlamıştım.
 controllera viewModel'i viewmodelin delegate'i ile bağlayacağım.
 */
import UIKit

final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate { // ViewModel protokolü eklendi

    //VIEW nesnesi:
    private let primaryView = RMLocationView()
   
    //VİEWMODEL nesnesi:
    private let viewModel = RMLocationViewViewModel()
    
    //MARK: -Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView) //RMLoactionView nesnesini burada ekledim.
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
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
    private func didTapSearch(){
        
    }
    
    //MARK: -Location ViewModel Delegate
    ///final classs protokol de eklendiği için bu protokol fonksiyonu da bu sınıfta görünür hale geldi.
    func didFetchInitialLocations(){
        primaryView.configure(with: viewModel)
    }

}
