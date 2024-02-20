//
//  CharacterListViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacter(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
    
}

// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    //CHARACTERS ARRAY
    private var characters: [RMCharacter] = [] {
        didSet { ///didSet characters dizisine her yeni değer atadıgında tetiklenir.
          ///burada amaç: characters dizisindeki her bir RMCharacter nesnesi için bir RMCharacterCollectionViewCellViewModel oluşturmak ve bu view model'ları başka bir diziye (cellViewModels varsayılan adıyla) eklemektir. Bu işlem, bir kullanıcı arayüzü koleksiyon görünümünde (örneğin, UICollectionView) gösterilmek üzere her bir karakter için ayrı bir view model hazırlar.*/
           // print("Creating view models")
            for character in characters{
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
                
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
              
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil ///ANLAMADIM ARAŞTIR.
    
    //FUNC FETCH CHARACTERS
    // fetch initial set of characters (20)
    public func fetchCharacters(){
        ///ağ isteği
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self){ [weak self] result in
            switch result{
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if additional characters are needed: yeni karakkterleri yükleme metodu.
    public func fetchAdditionalCharacters(url: URL){
        guard !isLoadingMoreCharacters else {
            return
        }
        //fetch characters
        isLoadingMoreCharacters = true
        print("fetching more characters")
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("failed to create request")
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info ///self? leri -> strongSelf ile değiştirdim
            
                 let originalCount = strongSelf.characters.count
                 let newCount = moreResults.count
                 let total = originalCount+newCount
                 let startingIndex = total - newCount
                 let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                     return IndexPath(row: $0, section: 0)
                 }) //ÇOK ÖNEMLİ NOT AL

                 strongSelf.characters.append(contentsOf: moreResults)

                print(strongSelf.cellViewModels.count)
                  DispatchQueue.main.async {
                   strongSelf.delegate?.didLoadMoreCharacter(with: indexPathsToAdd)
                     strongSelf.isLoadingMoreCharacters = false
                 }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false 
            }
        }
        
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil ///return false yaptıgımda footer görüntülenmiyor.
    }
    
}

// MARK: COLLECTIONVIEW VE FOOTER EXTENSION
extension RMCharacterListViewViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // FUNC NUMBER OF ITEM IN
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    // FUNC CELL FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else { fatalError("Unsupported cell") }
       
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    // FUNC VIEW FOR SUPPLEMENTARY = footer için
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView
            else { fatalError("Unsupported") }
        footer.startAnimating()
        return footer
    }
    
    // FUNC SIZE FOR FOOTER = footer sizeını belirleyeceğim.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    // FUNC SIZE FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        let height = width*1.5
        
        return CGSize(width: width, height: height)
    }
    
    // FUNC DIDSELECT
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}


//MARK: SCROLLVIEW EXTENSION
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    
    //didscroll func
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters, !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentheight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentheight-totalScrollViewFixedHeight-120){
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()

        }
    }
}

/*RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
 guard let strongSelf = self else {
     return
 }
 switch result {
 case .success(let responseModel):
     let moreResults = responseModel.results
     let info = responseModel.info
     strongSelf.apiInfo = info ///self? leri -> strongSelf ile değiştirdim
     
     // Yeni karakterler için view model'ler oluşturun ve cellViewModels'e ekleyin
     let newViewModels = moreResults.map { character in
         return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
     }
     
     DispatchQueue.main.async {
         let indexPathsToAdd: [IndexPath] = (strongSelf.cellViewModels.count..<(strongSelf.cellViewModels.count + newViewModels.count)).map { IndexPath(row: $0, section: 0) }
         
         // Önce cellViewModels dizisine yeni view model'leri ekleyin
         strongSelf.cellViewModels.append(contentsOf: newViewModels)
         
         // Sonra, collectionView'a yeni indexPaths ile hücreleri ekleyin
         strongSelf.delegate?.didLoadMoreCharacter(with: indexPathsToAdd)
         strongSelf.isLoadingMoreCharacters = false
     }
     
 case .failure(let failure):
     print(String(describing: failure))
     DispatchQueue.main.async {
         strongSelf.isLoadingMoreCharacters = false
     }
 }
}
*/

//ORGİNAL VERSİON

/*let originalCount = strongSelf.characters.count
 let newCount = moreResults.count
 let total = originalCount+newCount
 let startingIndex = total - newCount
 let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
     return IndexPath(row: $0, section: 0)
 }) //ÇOK ÖNEMLİ NOT AL

 strongSelf.characters.append(contentsOf: moreResults)

 


  DispatchQueue.main.async {
   strongSelf.delegate?.didLoadMoreCharacter(with: indexPathsToAdd)
     strongSelf.isLoadingMoreCharacters = true
 }*/
