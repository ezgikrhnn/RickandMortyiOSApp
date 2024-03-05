//
//  RMSearchViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 5.03.2024.
//

import UIKit

/// configurable controller to search
final class RMSearchViewController: UIViewController {
    
    ///type swift dilinde bir anahtar kelime oldugu için bunun enuma air oldugunu belirtmek için backstick kullanılır.
    private let config: Config
    
    struct Config{
        enum `Type` {
            case character
            case episode
            case location
        }
        
        let type: `Type`
        
    }

    init(config: Config){
        self.config = config
        super.init(nibName: nil, bundle: nil) ///bir view controller'ın varsayılan initializer'ını çağırır ve UIKit'in bu view controller'ı  yönetebilmesi için kurulumu yapar. genelikle programmaticuı'da kullanılır.
    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
      
    }
    
}
