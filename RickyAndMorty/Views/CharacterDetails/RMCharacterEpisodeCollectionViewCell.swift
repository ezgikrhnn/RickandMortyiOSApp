//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 18.02.2024.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: -Init:
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
        setUpConstraints()
    }

    required override init(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints(){ NSLayoutConstraint.activate([
        
        seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
        seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier:0.3),
        
        nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
        nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier:0.3),
        
        airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
        airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier:0.3),
        
        
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }

    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel){
        viewModel.registerForData{ [weak self] data in
           // print(data.name)
           // print(data.air_date)
           // print(data.episode)
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Aired on "+data.air_date
            self?.seasonLabel.text = "Episode "+data.episode
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}
