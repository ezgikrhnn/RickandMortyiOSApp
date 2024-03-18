//
//  CharacterListViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

/*
 SINIF AÇIKLAMASI:
 
 - PROTOKOL : Protocol içinde 3 tane fonksiyon barındırıyor. Bu fonksiyonlar RMCharackterListView içinde extension ierisinde kullanıldı.
 
 - DELEGATE NESNESİ:
 
 - ISLOADINGMORECHARACTERS BOOLU:
 
 - CHARACTERS ARRAYİ: RMCharacter arrayidir. Burada amaç her bir character için cellViewModel oluşturmak ve bu iewModelleri başka bir diziye eklemektir. didSet -> character dizisine her yeni değer atandığında tetiklenir.
 
 - CELLVİEWMODELS ARRAYİ: CollectionViewCellViewModel arrayidir. Characters arrayinin elemanlarını viewModele dönüştürüp bu arraye ekledim.
 
 - APIINFO NESNESİ: RMGetAllCharactersResponse.Info türünde bir nesne olup apiden gelen yanıtın bir parçasını temsil eder. uygulamanın ilgili bölümlerinde kullanılacak.
 
 - FETCHCHARACTERS FONKSİYONU: bu fonksiyon bir ağ isteği yaparak Rick and Morty API'sinden karakter listesini çeker. RMService sınıfının belirli bir örneğini kullanarak belirli bir endpoint'e (listCharactersRequest) ağ isteği yapar.gelen yanıt resulttır ve result üstünde switch ile başarı durumunu kontrol ederiz PI'den başarılı bir şekilde veri alındıysa, bu veri responseModel içinde RMGetAllCharactersResponse tipinde saklanır. Gerekli işlem ve atamalar yapıldıktan sonra dispatchQueue ile didLoadInitialCharacters() fonk cağırılır böylece ilgili görünüm güncellenir
 
 - FETCHADDITIONALCHARACTERS FONKSİYONU:  bu fonksiyon daha fazla karakter yüklemede kullanılır. Verilen kontroller sağlanır, url ile bir ağ isteği (request) tanımlanır. istek başarılı olurs RMService ile ağ yapılandırmasına geçilir.  API'den başarılı bir yanıt alınırsa, responseModel içerisinden yeni karakterler (moreResults) ve sayfalama bilgileri (info) alınır. Array işlemleri ile eklenecek index bulunur. ve son olrak güncelleme yapıldı.
 
 - SHOULDLOADMOREINDICATOR BOOLU: apiInfo bilgileri genellikle sayfalama bilgileri içerir.
            apiInfo.next = nil değilse yüklenmesi gereken başka veriler var demektir.
 
- COLLECTİONVİEW VE FOOTER EXTENSİONU:
 */

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacter(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
    
}

// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters  = false
    
    //CHARACTERS ARRAY
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters{ //her karakter için ayrı bir viewModel:
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
                //viewModel nesneleri bir arraye eklenir.
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
        ///expecting-> yenit olarak apiden hangi tip beklendiğini (RMGetAllCharactersResponse) tipinde
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self){ [weak self] result in
            print("character fetchi")
            switch result{
               
            case .success(let responseModel):
                let results = responseModel.results ///RMGetAllCharactersResponse türünde olduğu için results ve info isimli özellikleri var.
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                
                DispatchQueue.main.async { ///güncelleme
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if additional characters are needed: yeni karakkterleri yükleme metodu.
    public func fetchAdditionalCharacters(url: URL){
        guard !isLoadingMoreCharacters else { ///isLoadingMoreCharacters false mu kontrol et
            return
        }
        //fetch characters
        isLoadingMoreCharacters = true
        print("fetching more characters")
        
        ///verilen url ile ağ isteği
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("failed to create request")
            return
        }
        
        //ağ isteği gerçekleştirilir ve RMGetAllCharactersResponse türünde result beklenir
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

                 strongSelf.characters.append(contentsOf: moreResults) //characters listesine eklendi.

                //print(strongSelf.cellViewModels.count)
                //güncelleme:
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
        return apiInfo?.next != nil
    }
}



// MARK: COLLECTIONVIEW VE FOOTER EXTENSION
extension RMCharacterListViewViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // FUNC NUMBER OF ITEM IN
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count ///characterlerin olduğu array
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
