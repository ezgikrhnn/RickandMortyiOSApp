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
 
 
 StoreKit Kütüphanesi: uygulama içi staın alma işlemlerini yönetmek için kullanılır. (abonelikler, uygulama değerlendirmeleri, ödeme işlemlerini sorgulama..) bizim çalışmamızdaki amaç rate app eklemek oldu.
 */

import StoreKit
import SafariServices
import SwiftUI
import UIKit

final class RMSettingsViewController: UIViewController {

    ///controllerin settingsSwiftUIController isimli özelliği, UIHostingController'a referans tutar.
    ///UIHostingControllerın jenerik parametresi RMSettingsView'dir. bu UIHostingCntrollerin içinde RMSettingsView tipinde vir swiftUI görünümü barındıracağı anlamına gelir.
    ///
    private var settingsSwiftUIController: UIHostingController <RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController(){
        
        //buradaki çağırmalar olduça önemli dikkat et!!!
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

    // HANDLE TAP FONK:
    //ayar seçeneğina tıklandıgında ne olacağını tanımlar
    private func handleTap(option: RMSettingsOption){
        
        ///Bu fonksiyonun yalnızca ana iş parçacığı üzerinde çalıştığından emin oluyorum.
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            //openwebsite
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }else if option == .rateApp{
            
            //show rating prompt
            if let windowScene = view.window?.windowScene{
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

}
