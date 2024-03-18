//
//  RMSettingsViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//
/*
 Bu kod parçası SwiftUI ve UIKit'in birikte nasıl kullanılacağını gösteren bir çalıma içeriyor.
 SwiftUI'da oluşturulan bir ayarlar ekranı (RMSettingsView), UIKit tabanlı bir uygulamada bir UIViewController içinde gösterilmektedir.
 
 RMSettingsView -> SwiftUI ile yazılmıştır -> rootView'dir.
 
 addSwiftUIController() Fonksiyonu -->  Bu metod, settingsSwiftUIController'ı mevcut view controller'a bir child olarak ekler ve onun view'ini mevcut view controller'ın view hiyerarşisine yerleştirir. 
 */
import SwiftUI
import UIKit

final class RMSettingsViewController: UIViewController {


    //settings ekranı için gerekli tüm hücre viewModellarını içeren bir array oluşturdum:
    //bu dizi viewModel'ın cellViewModels parametresi olarak kullanılır.
    
    private var settingsSwiftUIController: UIHostingController <RMSettingsView>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController(){
        let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
            
            return RMSettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
            })
        )))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }

    private func handleTap(option: RMSettingsOption){
        guard Thread.current.isMainThread else {
            return
        }
        
        switch option {
        case .rateApp:
            //show promt
            break
        case .contactUs:
            <#code#>
        case .terms:
            <#code#>
        case .privacy:
            <#code#>
        case .apiReference:
            <#code#>
        case .viewSeries:
            <#code#>
        case .viewCode:
            <#code#>
        }
    }

}
