//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 18.02.2024.
//

import UIKit

protocol RMEpisodeDataRender {
    var episode: String {get}
    var air_date: String {get}
    var name: String {get}
}
final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable{
    
    
    private let episodeDataUrl: URL?
    public let borderColor : UIColor
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender)-> Void)?
    
    
    private var episode: RMEpisode? {
        didSet{
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
        
    }
    
    //MARK: - Init
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue){
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    
    public func fetchEpisode(){
        guard !isFetching else {
            if let model = episode{
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model 
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    //hash ve wquatable protokolleri fonksiyonları
    //*Bir nesnenin hem hash(into:) fonksiyonunu hem de == operatörünü uygulaması, bu nesnenin hem benzersiz bir şekilde tanımlanabilmesini sağlar hem de iki nesnenin birbirine eşit olup olmadığının karşılaştırılabilmesini sağlar. Bu, koleksiyonlar gibi veri yapılarında nesnelerin yönetilmesi ve performansın iyileştirilmesi için önemlidir. */
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
