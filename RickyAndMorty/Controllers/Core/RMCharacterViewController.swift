//
//  RMCharacterViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        print(request.url)
        RMService.shared.execute(request,
                                 expecting: RMCharacter.self){ result in
           
        }
    }
    


}


/**  let request = RMRequest(
 endpoint: .character,
 queryParameters: [
     URLQueryItem(name: "name", value: "rick"),
     URLQueryItem(name: "status", value: "alive")
 ]
)
print(request.url)*/
