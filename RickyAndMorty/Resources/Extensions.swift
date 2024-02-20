//
//  Extensions.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 8.02.2024.
//

import UIKit

extension UIView{
    
    /**... operatörü (variadic parametre), metodun birden fazla UIView nesnesi alabileceğini gösterir. **/
    func addSubviews(_ views: UIView...){
        views.forEach(){
            addSubview($0)
        }
    }
}
