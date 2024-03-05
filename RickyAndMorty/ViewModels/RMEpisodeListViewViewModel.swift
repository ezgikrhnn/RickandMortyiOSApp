//
//  RMEpisodeListViewViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//


import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisode(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
    
}

// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes  = false
    private let borderColors : [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    //CHARACTERS ARRAY
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes{ //her karakter için ayrı bir viewModel:
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemBlue ///eğer nilse systemblue kullan
                )
                //viewModel nesneleri bir arraye eklenir.
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
              
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil ///ANLAMADIM ARAŞTIR.
    
    //FUNC FETCH CHARACTERS
    // fetch initial set of characters (20)
    public func fetchEpisodes(){
        
      
       
        ///ağ isteği
        ///expecting-> yenit olarak apiden hangi tip beklendiğini (RMGetAllCharactersResponse) tipinde
        RMService.shared.execute(.listEpisodesRequest, expecting: RMGetAllEpisodesResponse.self){ [weak self] result in
            switch result{
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                
                DispatchQueue.main.async { ///güncelleme
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if additional episodes are needed: yeni karakkterleri yükleme metodu.
    public func fetchAdditionalEpisodes(url: URL){
        guard !isLoadingMoreEpisodes else { ///isLoadingMoreCharacters false mu kontrol et
            return
        }
        //fetch characters
        isLoadingMoreEpisodes = true
        print("fetching more episodes")
        
        ///verilen url ile ağ isteği
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("failed to create request")
            return
        }
        
        //ağ isteği gerçekleştirilir ve RMGetAllCharactersResponse türünde result beklenir
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info ///self? leri -> strongSelf ile değiştirdim
            
                 let originalCount = strongSelf.episodes.count
                 let newCount = moreResults.count
                 let total = originalCount+newCount
                 let startingIndex = total - newCount
                 let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                     return IndexPath(row: $0, section: 0)
                 }) //ÇOK ÖNEMLİ NOT AL

                 strongSelf.episodes.append(contentsOf: moreResults) //characters listesine eklendi.

                //print(strongSelf.cellViewModels.count)
                //güncelleme:
                  DispatchQueue.main.async {
                   strongSelf.delegate?.didLoadMoreEpisode(with: indexPathsToAdd)
                     strongSelf.isLoadingMoreEpisodes = false
                 }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreEpisodes = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}



// MARK: COLLECTIONVIEW VE FOOTER EXTENSION
extension RMEpisodeListViewViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // FUNC NUMBER OF ITEM IN
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count ///episodeların olduğu array
    }
    
    // FUNC CELL FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError("Unsupported cell") }
       
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
        let width = (bounds.width-20)
        
        return CGSize(width: width, height: 100)
    }
    
    // FUNC DIDSELECT
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
    
}


//MARK: SCROLLVIEW EXTENSION
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    
    //didscroll func
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes, !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentheight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentheight-totalScrollViewFixedHeight-120){
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()

        }
    }
}
