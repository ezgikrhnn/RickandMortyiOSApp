//
//  CharacterCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 8.02.2024.
//

import UIKit

/// single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    //IDENTIFIER
    static let cellIdentifier = "RMCharacterCollectionViewCell"
    
    //IMAGEVIEW
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] ///bu satır sayesinde imageView'in sadece üst 2 köşesine cornerRadius uygulandı.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()///closure
    
    //LABEL
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //STATUSLABEL
    private let statusLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    override init(frame:CGRect){ ///programmatic hücre başlatıcısı,
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView,nameLabel,statusLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) { ///storyboard ya da  xib başlatıcısı
        fatalError("Unsupported")    ///desteklenmediği için fatalError
    }
    
    //CONSTRATINTS FUNC
    private func addConstraints() {
        
            /*
             | Image      |
             | nameLabel  |
             | statusLabel|
             */
        
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),  ///5 padding verdim.
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),  ///5 padding verdim.
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -3),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
        ])
    }
    
    private func setUpLayer(){
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.label.cgColor //backgroundcolour'un tersi oldu
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.borderWidth = 0.7
        contentView.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func prepareForReuse() { ///hücre yeniden kullanılmak üzere hazırlandıgında çağrırlır.
        super.prepareForReuse() /// metod super.prepareForReuse() çağrısı yapmakta, reperareforreuse hücre yeniden kullanılmak için çağırıldıgında yazılır. ARAŞTIR YENİDEN !!!
        
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
   
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel){
        
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image ///weak self oldugu için
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
