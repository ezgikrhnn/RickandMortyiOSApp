//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 8.02.2024.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL: URL?
    
    
    // MARK: - Init
    init( characterName: String, characterStatus: RMCharacterStatus, characterImageURL: URL?){
       
        self.characterImageURL = characterImageURL
        self.characterName = characterName
        self.characterStatus = characterStatus
    }
    
    
    /**Bu gösterim, bir computed property'dir.  Computed property'ler, değerleri sabit olmayıp her erişildiğinde hesaplanan özelliklerdir. Bu örnekte, characterStatusText isimli bir computed property tanımlanmıştır. Bu property her çağrıldığında, characterStatus.rawValue ifadesi çalıştırılır ve sonucu döndürülür. **/
    public var characterStatusText : String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data,Error>) -> Void){
        // TODO: Abstract to do Image Manager 
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return }
        
        ///RMImageLoader sınıfındaki fonksiyonu çağırıyorum.
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    //MARK: Hashable functions:
    ///hashable özelliği bu fonksiyonla beraber kullanılmak zorundadır.
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    ///hashable özelliği bu fonksiyonla da beraber kullanılmak zorundadır.
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
