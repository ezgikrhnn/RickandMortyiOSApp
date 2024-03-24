//
//  RMLocationViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 20.03.2024.
//

import Foundation

//PROTOKOL
protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations() //veriler fetch edildikten sonra kullanılacak fonksiyon
}


final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    //Array
    private var locations: [RMLocation] = []
    
    //Location response info
    // will contain next url, if present
    private var cellViewModels: [String] = []
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    init(){
        
    }
    
    //FETCH LOCATIONS VIEW
    public func fetchLocations(){
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            
            switch result{
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
               
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
