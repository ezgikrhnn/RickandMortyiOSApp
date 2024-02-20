//
//  RMEpisode.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 3.02.2024.
//

import Foundation

struct RMEpisode: Codable, RMEpisodeDataRender{ ///RMEpisodeDataRender collectionViewcellviewmodel içinde tanımladıgım bir protokol.
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
