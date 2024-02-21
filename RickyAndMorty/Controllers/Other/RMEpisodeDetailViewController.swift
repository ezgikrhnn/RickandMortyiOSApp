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

    private let url: URL?
    
    //MARK: -Init
    init(url: URL?){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
  
    //MARK: -Init
    required init(coder: NSCoder){
        fatalError()
    }
   

}
