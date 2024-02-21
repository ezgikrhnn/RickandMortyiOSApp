//
//  CharacterListView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
/*
 SINIF AÇIKLAMASI:
 
 - DELEGASYON PATERNİ: RMCharacterListViewDelegate protokolü delegasyon paterni ile karakter seçimindeki yönergeleri uygular.
 - delegate propertysi
 - viewModel nesnesi
 - spinner nesnesi         : (ve closure içinde bazı özellikleri)
 
 - collectionView nesnesi  : (ve closure içinde bası özellikleri) -> bu aşamada viewcell sınıfı ve bu sınıfın viewCellViewMode sınıfı da oluşturuldu. CV'ye  alt kısımda ekstra bilgi için footer da yapıldı, bu aşamada footerView sınıfı oluşturuldu. BUrası daha fazla veri yüklerken kullanılacak.
 
 - overrideInit fonksiyonu : gerekli nesneler ve gerekli fonksiyonlar burada çağırıldı.
 
 - requiredInit fonksiyonu : bir sınıf içinde required başlatıcı varsa bu sınıftan üretilen her alt sınıf bu başlatıcıyı kullanmalıdır. bu fonk genelde UIView yapılarında kullanılır.
 
 - Constraints fonksiyonu  :
 
 - SetUpCollectionView Fonk: datasource ve delegateini elf değil viewModel'e atadım.
 
 - Extension               : protocol extend edildi ve burada 3 farklı fonksiyon yapıldı.
    * didSelectCharacter        -> kullanıcı bir charactere tıkladıgında çalışır.
    * didLoadInitialCharacters  -> character listesinin ilk defa yüklenmesi işlemi tamamlandığında çağrılır.
    * didLoadMoreCharacter      -> sayfalama (pagination) işlemi sırasında daha fazla character yüklendiğinde  çalışır.
 
 */

import UIKit



protocol RMCharacterListViewDelegate: AnyObject{
    func rmCharacterListView(_ characterListView: RMCharacterListView,
                             didSelectCharacter character: RMCharacter)
}

final class RMCharacterListView: UIView {

    public weak var delegate: RMCharacterListViewDelegate? ///protocolden bir property oluşturdum
    
    //View model nesnesi
    private let viewModel = RMCharacterListViewViewModel()
    
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
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier:RMCharacterCollectionViewCell.cellIdentifier )
        
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
        viewModel.fetchCharacters()
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
    
    ///performBatchUpdates -> yeni hücreler sorunsuz ve animasyonlu şekilde yüklenir.
    func didLoadMoreCharacter(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates{
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}


