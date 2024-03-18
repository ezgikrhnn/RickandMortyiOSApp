//
//  RMSettingsOption.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 17.03.2024.

/*
 AYARLAR SEÇENEKLERİ
 
bu struct ayarlar ve menü seçeneklerini içeriyor. caseIterable protocolunden yararlanarak tüm durumları koleksiyon olarak listelememize olanak sağlar (allCases)
 */

import UIKit

enum RMSettingsOption: CaseIterable{
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl: URL? {
        
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https//: iosacademy.io")
        case .terms:
            return URL(string: "https//: iosacademy.io/terms")
        case .privacy:
            return URL(string: "https//: iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https//: iosacademy.io")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/watch?v=EZpZDuOAFKE&list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y")
        case .viewCode:
            return URL(string: "https://github.com/ezgikrhnn/RickandMortyiOSApp")
        }
    }
    
    
    var displayTitle : String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Tersm of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    var iconContainercolor: UIColor{
        switch self {
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemYellow
        case .terms:
            return .systemPurple
        case .privacy:
            return .systemPink
        case .apiReference:
            return .systemBrown
        case .viewSeries:
            return .systemGreen
        case .viewCode:
            return .systemOrange
        }
    }
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
       
}


