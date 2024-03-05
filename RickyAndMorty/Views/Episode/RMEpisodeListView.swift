//
//  RMEpisodeListView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//

import UIKit

protocol RMEpisodeListViewDelegate : AnyObject {
    func rmEpisodeListView(
        _ epiodeListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode
    )
}
final class RMEpisodeListView : UIView {
    public weak var delegate: RMEpisodeListViewDelegate?
    
    //View model nesnesi
    private let viewModel = RMEpisodeListViewViewModel()
    
    //SPINNER:
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //COLLECTION VİEW
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) /// collectionview hücre aralıkları
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0 //opacity
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //cell
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier:RMCharacterEpisodeCollectionViewCell.cellIdentifier )
        
        ///footer
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        return collectionView ///return unutma!
    }()
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner) /// resources/extension dosyası içindeki
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setUpCollectionView()
    }
    
    //REQUIRED INIT:
    required init?(coder: NSCoder){
        fatalError("Unsupported")
    }
    
    //CONSTRAINST:
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //SETUP COLLECTIONVIEW:
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel ///viewmodel ViewModel'dan extend edilen nesne. ViewModel içinde extension ve fonksiyonlarını yazdım.
        collectionView.delegate = viewModel
    }
}

//EXTENSION:
extension RMEpisodeListView : RMEpisodeListViewViewModelDelegate {
    //karakter başlatıcı
    func didLoadInitialEpisodes() {
        spinner.stopAnimating() ///spinner ayarını burada kullanarak cok daha hızlı işlem yaptım.
        collectionView.isHidden = false
        collectionView.reloadData() //Initial fetch
        UIView.animate(withDuration: 0.4){
            self.collectionView.alpha = 1
        }
    }
    
    ///performBatchUpdates -> yeni hücreler sorunsuz ve animasyonlu şekilde yüklenir.
    func didLoadMoreEpisode(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates{
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
  //protokol içindeki fonksiyonlar
    //karaktere tıklandıgında
    func didSelectEpisode(_ episode: RMEpisode) {
        //delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    
    
    
}
