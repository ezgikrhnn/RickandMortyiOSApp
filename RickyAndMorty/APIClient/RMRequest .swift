//
//  RMRequest .swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.
//

import Foundation

/// object that represents a single API
final class RMRequest{
    //API Constants
    private struct Constants {
        static let baseUrl =  "https://rickandmortyapi.com/api"
    }
    
    //Desired Endpoint
    private let endpoint: RMEndPoint
    
    //Path components for API, if any
    private let pathComponents: Set<String>
    
    //Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constucted url for the api request in string format
    private var urlString: String{
        var string = Constants.baseUrl /// constants kodun okunulabilirliğini arttırır.
        string += "/"
        string += endpoint.rawValue ///rawValue enum değerler için kullanılır. RMEndpoint bir enum yapısıydı.
        
        
        if !pathComponents.isEmpty{
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
                
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    // Computed & constructed API Url
    public var url: URL?{
        return URL(string: urlString)
    }
    
    //Desired HTTP Method
    public let httpMethod = "GET"
    
    /**
     Construct Request:
        Parameters:
        - endpoint: target endpoint
        - pathComponents: Collection of path components
        - queryParameters: collection of query parameters
     
     */
    public init(endpoint: RMEndPoint, pathComponents: Set<String> = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}
