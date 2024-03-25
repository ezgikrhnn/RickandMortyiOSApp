//
//  RMLocationTableViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 24.03.2024.
//
/**
 tableviewcell verileri için VİEWMODEL
 
 HASHABLE VE EQUATABLE PROTOKOLLERİ:
  Bu iki protokol veri tiplerinn benzersiliğinin sağlanması gereken durumlarda kullanılır.
    equatable protokolu -> iki nesnenin == eşitliğinin kontrol edilmesini sağlar.
    hashable protokolu -> iki nesnenin benzersiz has değeri üretmesini sağlar. hashable equatableı genişletir.YANİ: hashable bir tür otomatik olarak equatable olmalıdır.
 */
import Foundation


struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    
    private let location: RMLocation
    
    init(location: RMLocation){
        self.location = location
    }
    
    public var type: String {
        return location.type
    }
    
    public var name: String{
        return location.name
    }
    
    public var dimension: String{
        return location.dimension
    }
    
    //PROTOKOL FONKSİYONLARI:
    //Equatable fonk:
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    //hashable fonk.
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
    
}
