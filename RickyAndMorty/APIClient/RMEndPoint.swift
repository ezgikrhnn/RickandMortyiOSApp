//
//  RMEndPoint.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.
//

import Foundation

/// represents uniques API endpoint
@frozen enum RMEndPoint: String{
    
    /// endpoint to get character info
    case character
    case location
    case episode
}
