//
//  RMLocationTableViewCell.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 24.03.2024.
//

/*
 CONFİGURE FONKSİYONU: cellviewModel'ı burada configure ettim.
 
 */

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "RMLocationTableViewCell"
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMLocationTableViewCellViewModel){
        
    }
    
}
