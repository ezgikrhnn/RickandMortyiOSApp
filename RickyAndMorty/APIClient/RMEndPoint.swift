//
//  RMEndPoint.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.

/**
 RMEndPoint Enum'ı:
 
 API'nin farklı uç noktalarını (endpoints) temsil eder. Bu örnekte, character, location, ve episode gibi Rick and Morty API'sinin temel uç noktaları tanımlanmıştır.
 RMRequest class'ı ile doğrudan ilişkilidir çünkü her bir RMRequest instance'ı, hangi API uç noktasına istek yapıldığını belirtmek için bir RMEndPoint değeri alır.
*/

import Foundation

/// represents uniques API endpoint
@frozen enum RMEndPoint: String{
    
    /// endpoint to get character info
    case character
    case location
    case episode
}
