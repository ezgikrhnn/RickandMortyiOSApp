//
//  RMRequest .swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.

/**
 RMRequest Class'ı:
 
 Bu class, API'ye yapılan bir isteği temsil eder. API'nin temel URL'si, istek yapılacak spesifik uç nokta (endpoint), yol bileşenleri (pathComponents), ve sorgu parametreleri (queryParameters) gibi detayları içerir.
 RMEndPoint enum'ı ile etkileşime girer çünkü her bir istek, bir endpoint değeri alır ve bu değer RMEndPoint enum'ından gelir. Bu sayede, hangi API uç noktasına istek yapıldığını belirtir.
 API isteği oluşturulurken, url özelliği, tüm bu bilgileri birleştirerek tam bir URL string'i oluşturur ve bu string'i bir URL nesnesine dönüştürür.*/

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
    private let pathComponents: [String]
    
    //Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    
    /// Constucted url for the api request in string format: COMPUTED PROPERTY'dir.
    private var urlString: String{
        var string = Constants.baseUrl /// constants kodun okunulabilirliğini arttırır.
        string += "/" /// rickandmortyapi.com/api/    şeklinde oldu
        string += endpoint.rawValue ///rawValue enum değerler için kullanılır. RMEndpoint bir enum yapısıydı. ->
        /// rickandmortyapi.com/api/character  seklinde oldu
        
        /**Aşağıdaki kodun açıklaması:
         pathComponents olarak ["1", "2"] verilmişse ve string'in mevcut değeri
         rickandmortyapi.com/api/character" ise, döngü tamamlandıktan sonra string değişkeninin değeri rickandmortyapi.com/api/character/1/2 olur." **/
        if !pathComponents.isEmpty{
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        
        if !queryParameters.isEmpty{ ///queryParameters arrayi boş mu kontrol et
            string += "?"            ///url'e ? eklenir
            let argumentString = queryParameters.compactMap({ ///compactMap dizi üzerinde dönüp her bir eleman için belirli bir işlem yapar.
                
                /**guard let value = $0.value else {return nil} satırı ile her bir URLQueryItem'ın değeri kontrol edilir. Eğer bu değer nil ise, bu eleman sonuç listesine dahil edilmez. Bu, sorgu parametresinin bir değere sahip olması gerektiğini garanti altına alır.
                 Örneğin, queryParameters [URLQueryItem(name: "name", value: "rick"), URLQueryItem(name: "status", value: "alive")] olarak belirlenmişse, bu işlemler sonucunda URL'ye ?name=rick&status=alive şeklinde bir ek yapılmış olur. Bu, API'ye name ve status parametreleri ile bir sorgu yapılacağını belirtir.*/
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    
    //urlString nesnesini al URL nesnesine dönüştür.
    public var url: URL?{
        return URL(string: urlString)
    }
    
    
    //http method get
    public let httpMethod = "GET"
    
    //MARK: -Init
   //*Public init sınıfın ana başlatıcısıdır. Gerekli tüm parametreleri alır ve RMRequest nesnesini bu parametrelerle başlatır.***/
    public init(endpoint: RMEndPoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    //CONVENIENCE INIT
    //**convinience init sınıf için bir yardımcı başlatıcıdır. Zaten var olan bir url nesnesinden bir RMRequest nesnesi oluşturmak için kullanılır. İçerisinde URL'yi analiz eder, gerekli endpoint, pathComponents, ve queryParametersı çıkarır ve bu bilgilerle ana public init'i çağırır.**/
    convenience init?(url: URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil ///baseurl ile başlamıyorsa nil
        }
       
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents : [String] = []
                if components.count > 1{
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndPoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        }else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                //value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else{
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let rmEndpoint = RMEndPoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
        }
    }

extension RMRequest{
    static let listCharactersRequest = RMRequest(endpoint: .character)
}

