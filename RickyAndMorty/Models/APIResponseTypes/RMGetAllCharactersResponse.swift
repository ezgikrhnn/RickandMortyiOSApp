//
//  GetCharactersResponse.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 7.02.2024.
//

import Foundation

struct RMGetAllCharactersResponse : Codable {
    struct Info: Codable {
        let count : Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMCharacter] ///dataTypes sınıfı içinde tanımlı RMCharacters
}
