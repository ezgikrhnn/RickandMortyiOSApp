//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 18.02.2024.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    ///cellIdentifier = sınıfın kendisine ait oldugundan static
    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    required override init(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    override func prepareForReuse() {
        /***prepareForReuse fonksiyonu, UITableView ve UICollectionView hücrelerinde kullanılır. Bir hücre yeniden kullanılmak üzere hazırlanırken çağrılır. Bu metod, hücrenin eski durumundan kalıntılarını temizlemek, eski verileri sıfırlamak ve hücreyi yeni veri ile doldurmadan önce varsayılan bir duruma getirmek için kullanılır.*/
        super.prepareForReuse()
        imageView.image = nil
    }

    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel){
        viewModel.fetchImage{ [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure:
                break
            }
        }
    }
}
