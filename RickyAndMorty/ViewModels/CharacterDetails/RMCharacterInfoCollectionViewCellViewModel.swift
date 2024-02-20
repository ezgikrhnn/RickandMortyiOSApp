//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 18.02.2024.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel{
    
    private let type: `Type`
    public let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSSZ"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String{
        if value.isEmpty{
            return "None"
        }
        
        if let date = Self.dateFormatter.date(from: value), type == .created{
         
            return Self.shortDateFormatter.string(from: date)
           
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        type.tintColor
    }
    
    enum `Type` : String{
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor{
            
            switch self{
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemGreen
            case .species:
                return .systemPurple
            case .origin:
                return .systemPink
            case .created:
                return .systemOrange
            case .location:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
        }
        
        var iconImage: UIImage?{
            
            switch self{
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        
        var displayTitle: String {
            
            
            switch self{
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "Episode Count"
                
            }
        }
    }

    
    init(type: `Type`, value: String){
        self.value = value
        self.type = type
    }
}


