//
//  RMEpisodeDetailViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 22.02.2024.
//
/*
 1 EPİSODE HAKKINDA DETAYLAR İÇEREN VİEW CONTROLLER:

 Sınıfta 2 tane init vardır. init(url:URL) ve required init() fonksiyonları.
 */

import UIKit

final class RMEpisodeDetailViewController: UIViewController {

    private let viewModel: RMEpisodeDetailViewViewModel
    private let detailView = RMEpisodeDetailView()
    
    //MARK: -Init
    init(url: URL?){
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(detailView)
        title = "Episode"
        view.backgroundColor = .systemGreen
        addConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self , action: #selector(didTapShare))
    }
  
    //MARK: -Init
    required init(coder: NSCoder){
        fatalError()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    ///selector oldugu için @objc
    @objc
    private func didTapShare(){
        
    }

}
