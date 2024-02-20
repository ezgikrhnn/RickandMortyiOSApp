//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 18.02.2024.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel{
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?){
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error> ) -> Void){ ///fonksiyon bize bazı DATA ve ERROR'larla RESULT return edecek.
       ///hazırda olan downloadImage fonksiyonunu kullanıyorum
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
