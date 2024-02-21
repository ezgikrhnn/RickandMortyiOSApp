//
//  RMCharacterDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 10.02.2024.
//

import UIKit

//DETAIL PAGE VIEWMODEL

final class RMCharacterDetailViewViewModel{
    
    private let character : RMCharacter ///bir character gelecek
    public var episodes: [String] {
        character.episode
    }
    
    enum SectionType{
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections : [SectionType] = []
    
    //MARK: -Init
    init(character: RMCharacter){ ///bu viewodelda bir karakterin detayı gösterileceği için character aldı.
        self.character = character
        setUpSections()
    }
    
    private func setUpSections(){
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value: character.status.text),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)"),
             
        ]),
            .episodes(viewModels:character.episode.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
    ]
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
        
    }
    
    //MARK: - SECTION LAYOUTS:
    
    public func createPhotoSectionLayout()-> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createEpisodesSectionLayout()-> NSCollectionLayoutSection{
        ///item groupun içinde olduğu için 1.0 1.0 demek grubun oranıyla eş demek, fakat örneğin fractionalwidth = 0.5 olsaydı genişlik bulundugu grubun yarısı kadar olacaktı, sayfanın değil.
        ///fractional = oransal, absolute = kendi verdiğimi yüksekliktir.
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    public func createInformationSectionLayout()-> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(150.0)),
            subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
  
}
