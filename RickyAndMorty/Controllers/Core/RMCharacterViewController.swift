//
//  RMCharacterViewController.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

/*
 - Bu UIController sınıfı karakter listesini görüntüler ve kullanıcı bir karakteri seçtiğinde detay sayfasına geçiş olur.
 - RMCharacterListViewDelegate protokolünü uygulayarak, karakter listesi görünümünden (view) geri bildirim alıyor
 - viewDidLoad içinde arkaplan title gibi özellikler verildi.*/

import UIKit

final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {
    
    private let characterListView = RMCharacterListView()
    
    //GÖRÜNÜM YAPILANDIRMALARI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        view.addSubview(characterListView)
        setUpView()
    }
    
    private func setUpView(){
        characterListView.delegate = self
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //RMCHARACTERLİSTVİEWDELEGATE UYGULAMASI
    /*
     RMCharacterListViewDelegate metodu kullanıcı bir karakteri seçtiğinde çağırılır.
     Bu metod içinde, seçilen karakter için bir RMCharacterDetailViewViewModel oluşturulur ve bu viewModel kullanılarak RMCharacterDetailViewController'ın bir örneği yaratılır.
     */
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true) ///detay sayfasına geçiş.
        detailVC.navigationItem.largeTitleDisplayMode = .never ///sayfa başlıkları büyük olmasın.
    }
}
    

