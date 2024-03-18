//
//  RMSettingsCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 17.03.2024.
//
/**
 Burada ayarlar ekranı için hücre modeli tanımlayan bir struct oluşturuldu. Bu yapı, RMSettingsOption enum'undan bir örneği (type) saklar ve bu enum'a bağlı olarak hücrenin gösterim detaylarını (image ve title) sağlar.
 */

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    let id = UUID()
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    //MARK: -Init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void){
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    //MARK: -Public
    //Image | title
    public var image: UIImage? {
        return type.iconImage
    }
    public var title : String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor{
        return type.iconContainercolor
    }
}


