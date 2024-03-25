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
    private var locations: [RMLocation] = [] {
        didSet{
            for location in locations {
              
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel){
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    //Location response info
    // will contain next url, if present
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
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
                    print("location geliyo")
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
