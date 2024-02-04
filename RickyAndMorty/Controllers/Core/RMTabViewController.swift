//
//  ViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 1.02.2024.
//

import UIKit

final class RMTabViewController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }


    private func setUpTabs(){
        
        let charactersVC = RMCharacterViewController()
        let episodesVC = RMEpisodeViewController()
        let locationVC = RMLocationViewController()
        let settingsVC = RMSettingsViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        charactersVC.title = "Characters"
        episodesVC.title = "Episodes"
        locationVC.title = "Location"
        settingsVC.title = "Settings"
    
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: episodesVC)
        let nav3 = UINavigationController(rootViewController: locationVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        //setViewController = tab bar'ın içeriklerini yönetmek için kullanılır.
        setViewControllers(
                [nav1, nav2, nav3, nav4],
                animated: true)
    }

    
}

