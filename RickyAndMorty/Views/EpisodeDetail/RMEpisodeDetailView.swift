//
//  RMEpisodeDetailView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter
    )
}
final class RMEpisodeDetailView: UIView {

    public weak var delegate : RMEpisodeDetailViewDelegate?
    
    private var viewModel: RMEpisodeDetailViewViewModel?{
        didSet{
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3){
                self.collectionView?.alpha = 1
            }
        }
    }
    
    //Collection View
    private var collectionView: UICollectionView?
    
    //SPINNER
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
        addConstraints()
        spinner.startAnimating()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("unsupported")
    }

    private func addConstraints(){
        guard let collectionView = collectionView else {
            print("hatalı")
            return
        }
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    //CREATE COLLECTION VIEW
    private func createCollectionView()-> UICollectionView{
        let layout = UICollectionViewCompositionalLayout{ section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        
        return collectionView
        
    }
    
    //MARK: Public
    public func configure(with viewModel: RMEpisodeDetailViewViewModel){
        self.viewModel = viewModel
    }
}



extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //NUMBER OF SECTION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    //NUMBER OF ITEM IN SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    // CELL FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sections = viewModel?.cellViewModels else {
            fatalError("No viewModel")
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    //DID SELECT ITEM
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else {
            return
        }
    
        let sections = viewModel.cellViewModels
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
          break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
        
    }
    
}

extension RMEpisodeDetailView{
    
     func layout(for section: Int) -> NSCollectionLayoutSection{
         guard let sections = viewModel?.cellViewModels else {
             return createInfoLayout() }
         
         switch sections[section]{
         case .information:
             return createInfoLayout()
        case .characters:
             return createCharacterLayout()
             
         }
    }
    
    func createInfoLayout() -> NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
        
    }
}
