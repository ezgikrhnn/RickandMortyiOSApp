//
//  RMFooterLoadingCollectionReusableView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 11.02.2024.
//

import UIKit

/*
 Footer veya header collectionview altında veya üstünde ek bilgileri göstermek için kullanılır;
 örneğin galeri uygulaması altında gösterilen fotoğraf sayısı gibi.
 */

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "RMFooterLoadingCollectionReusableView"
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
        
    }()
    
    override init(frame:CGRect ){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
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
        ])
    }
    //viewmodel içinde bu fonksiyon çağırıldı.
    public func startAnimating(){
        spinner.startAnimating()
    }
    
}
