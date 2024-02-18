//
//  RMCharacterDetailView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 10.02.2024.
//

import UIKit

///view for single character info
final class RMCharacterDetailView: UIView {

    //COLLECTIONVIEW
    public var collectionView: UICollectionView?
    
    //VIEWMODEL
    private let viewModel: RMCharacterDetailViewViewModel
    
    //SPINNER:
    private  let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: -Init
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
       
       let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints(){
        guard let collectionView = collectionView else {
            return
        }
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
    
    private func createCollectionView() -> UICollectionView{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) ///.zero frame ekranın tamamını kaplayacak şekilde anlamına geliyor.
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false 
        return collectionView
    }
    
    ///layoutların her bir bölümü olan sectionları oluşturan nasıl görüneceğini belirleyen fonksiyon:
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection{
       
        let sectionTypes = viewModel.sections
        
        switch sectionTypes[sectionIndex] {
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        }
        
        
    }
    

    
}


