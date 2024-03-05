//
//  RMEpisodeViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

import UIKit

final class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate {

    private let episodeListView = RMEpisodeListView()
    
    //GÖRÜNÜM YAPILANDIRMALARI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addSearchButton()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapShare))
    }
    
    @objc
    private func didTapShare(){
        
    }
    
    private func setUpView(){
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
  
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
