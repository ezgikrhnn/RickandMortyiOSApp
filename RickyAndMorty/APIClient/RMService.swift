//
//  RMService.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.
//

import Foundation

/// Primary API service object to get Rixk and Morty data

final class RMService {
    static let shared = RMService()
    
    private init(){
    }
    
    /**
    Send Rick and Morty API Call
    Parameters:
    - request: request instance
    - type: the type of object we expect to get back
    - completion: callback with the data or error
                        
                
     */
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping(Result<T, Error>) -> Void
    ){
        
    }
}
