//
//  CharacterListView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

import UIKit

///final eklendiğinde bu sınıfın başka hiçbir sınıftan miras alınamaz.
///final ile bu sınıf değiştirilemez gibi düşünebilirim
// View that handles showing list of characters, loader, etc.
final class RMCharacterListView: UIView {

    ///object from viewmodel
    private let viewModel = CharacterListViewViewModel()
    
    //SPINNER: dönen loading işaret
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //COLLECTION VİEW
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) /// collectionview hücre aralıkları
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true ///default olarak saklı olsun.
        collectionView.alpha = 0 ///opaklık = opacity ayarı
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView ///return unutma!
    }() ///closure belirttiği için () kullanılır.
    
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner) /// resources/extension dosyası içindeki
        addConstraints()
        spinner.startAnimating()
        viewModel.fetchCharacters()
        setUpCollectionView()
    }
        
    required init?(coder: NSCoder){
        fatalError("Unsupported")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel ///viewmodel ViewModel'dan extend edilen nesne. ViewModel içinde extension ve fonksiyonlarını yazdım.
        collectionView.delegate = viewModel
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 0.4){
                self.collectionView.alpha = 1
            }
        })
    }
}
