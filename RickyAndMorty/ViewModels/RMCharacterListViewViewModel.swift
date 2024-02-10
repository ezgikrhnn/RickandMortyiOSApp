//
//  CharacterListViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

import UIKit

final class RMCharacterListViewViewModel: NSObject {
    
    func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequest, expecting: GetAllCharactersResponse.self){ result in
            switch result{
            case .success(let model):
                print("Total:"+String(model.info.count))
                print("Page result count:"+String(model.results.count))
            case .failure(let error):
                print(String(describing: error))
                
            }
        }
    }
}

extension RMCharacterListViewViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }
    
    //size belirlemek için size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        let height = width*1.5
        
        return CGSize(width: width, height: height)
    }
}
