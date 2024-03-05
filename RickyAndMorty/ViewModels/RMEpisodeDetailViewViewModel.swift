//
//  RMEpisodeDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//

import UIKit

class RMEpisodeDetailViewViewModel {

    private let endpointUrl : URL?
    
    init(endpointUrl: URL?){
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData(){
        guard let url = endpointUrl, let request = RMRequest(url: url) else{ return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure:
                break
            }
        }
    }
}
