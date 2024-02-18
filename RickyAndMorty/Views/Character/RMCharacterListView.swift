//
//  CharacterListView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject{
    func rmCharacterListView(_ characterListView: RMCharacterListView,
                             didSelectCharacter character: RMCharacter)
}
///final eklendiğinde bu sınıfın başka hiçbir sınıftan miras alınamaz.
///final ile bu sınıf değiştirilemez gibi düşünebilirim
// View that handles showing list of characters, loader, etc.
final class RMCharacterListView: UIView {

    public weak var delegate: RMCharacterListViewDelegate? ///protocolden nesne
    
    ///object from viewmodel
    private let viewModel = RMCharacterListViewViewModel()
    
    //SPINNER: dönen loading işaret
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
        collectionView.isHidden = true ///default olarak saklı olsun.
        collectionView.alpha = 0 ///opaklık = opacity ayarı
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier:RMCharacterCollectionViewCell.cellIdentifier )
        
        //foofterCollectionView Register ediyorum:
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        return collectionView ///return unutma!
    }() ///closure belirttiği için () kullanılır.
    
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner) /// resources/extension dosyası içindeki
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setUpCollectionView()
    }
        
    required init?(coder: NSCoder){
        fatalError("Unsupported")
    }
    
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
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel ///viewmodel ViewModel'dan extend edilen nesne. ViewModel içinde extension ve fonksiyonlarını yazdım.
        collectionView.delegate = viewModel
    }
}

extension RMCharacterListView : RMCharacterListViewViewModelDelegate {
  //protokol içindeki fonksiyonlar
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        collectionView.reloadData()
        spinner.stopAnimating() ///spinner ayarını burada kullanarak cok daha hızlı işlem yaptım.
        collectionView.isHidden = false
        collectionView.reloadData() //Initial fetch
        UIView.animate(withDuration: 0.4){
            self.collectionView.alpha = 1
        }
    }
    
    ///bu fonksiyon siteye yeni veriler eklendiğinde bu yeni verileri içeren colectionviewe hücreler eklemek için kullanılır.
    ///bu fonk. genellikle sayfalama (pagination) işlemlerinde kullanıcı daha fazla veri istediğinde çağırılır.
    ///performBatchUpdates yöntemi ile birlikte, UICollectionView'ın yeni hücreleri sorunsuz bir şekilde ve animasyonlu bir şekilde eklemesinş sağlar.
    func didLoadMoreCharacter(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates{
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}


