//
//  RMEpisodeDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject{
    func didFetchEpisodeDetails()
    
}
final class RMEpisodeDetailViewViewModel {

    private let endpointUrl : URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet{
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    public private(set) var cellViewModels: [SectionType] = []
   
    
    //MARK: -Init
    init(endpointUrl: URL?){
        self.endpointUrl = endpointUrl
        
    }
    //MARK: -Public
    public func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        ///date(from:) aldıgı string parametreyi date türüne dönüştürür.
        ///öncelikle viewmodel üzerindeki datFormatter ile tarihi yapıladırıyorum bunun üzerinden date(from:) ile gerekli nesneye yapılandırmayı uyguladım.
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) 
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                
                return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
            }))
        
        ]
    }
    
    public func character(at index: Int) -> RMCharacter?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    
    
    // Fetch backing episode model
    public func fetchEpisodeData(){
        guard let url = endpointUrl, let request = RMRequest(url: url) else{
            return
            
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            
            print("içeride")
            switch result {
            case .success(let model):
                print("başarılı")
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                print("başarısız")
                break
            }
            
        }
        
    }
    
    //MARK: -Private
    private func fetchRelatedCharacters(episode: RMEpisode){
        /**episode.characters dizisi içinde bulunan karakter URL'lerini (String türünde) önce URL nesnelerine dönüştürür. Daha sonra, bu URL'ler kullanılarak RMRequest nesneleri oluşturur. Her iki dönüşüm işlemi için de compactMap kullanılmıştır, bu sayede dönüşüm sırasında oluşabilecek herhangi bir nil değer otomatik olarak atılmış olur ve sonuçta nil olmayan değerlerden oluşan bir dizi elde edilir.**/
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        //10 of parallel requests
        //notified once all done
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer{
                    group.leave()
                }
                switch result{
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
        
    }
}
