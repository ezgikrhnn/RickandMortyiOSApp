//
//  RMService.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 4.02.2024.
//
/**
 RMService Class'ı:
 Bu class, API isteklerini göndermek ve yanıtları almak için kullanılır. Singleton deseni kullanılarak (shared instance) uygulama boyunca tek bir instance üzerinden erişim sağlanır.
 execute fonksiyonu ile, belirli bir RMRequest alır, bu isteği gönderir ve sonucu bir completion handler ile döndürür. Bu sonuç başarılı bir Codable tipindeki veri ya da bir hata (Error) olabilir. Bu, API'den gelen verilerin parse edilip uygulama içinde kullanılabilmesi için genel bir yapı sağlar.
 
 RMService bir RMRequest alır, bu RMRequest bir RMEndPoint'e (ve diğer parametrelere) dayanarak oluşturulur. Sonrasında RMService, bu isteği API'ye gönderir ve bir sonuç alır. Bu yapı, bir API ile etkileşimde bulunmak için temiz ve organize bir yol sunar. RMEndPoint uç noktaların tanımını sağlarken, RMRequest bu uç noktalara yapılacak isteklerin detaylarını belirler ve RMService, bu istekleri gerçekleştirip sonuçları işler.**/

import Foundation

/// Primary API service object to get Rick and Morty data

final class RMService {
    static let shared = RMService()
    private let cacheManager = RMAPICacheManager()
    
    /// Dışarıdan sınıfın örneklendirilmesini engellemek için private bir constructor tanımlanmıştır. Bu, shared üzerinden erişimi zorunlu kılar.
    private init(){
    }
    
    ///errorlar için enum yarattım
    enum RMServiceError : Error{
        case failedToCreateRequest
        case failedToGetData
    }
    
    //EXECUTE FUNC
    //*parametre = request (RMRequest sınıfından).*/
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping(Result<T, Error>) -> Void){
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            
            print("Using cache API response")
            do{
                let result = try JSONDecoder().decode(type.self, from: cachedData)
            }catch{
                completion(.failure(error))
            }
            return
        }
            
            
        ///request nesnesini request() fonk. kullanarak url'e çevirmeye çalış:
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        ///data task (ağ isteği) oluşturma ve başlatma: istek urlRequest kullanılarak API'ye yapılır.
        let task = URLSession.shared.dataTask(with: urlRequest){ [weak self] data, _, error in ///response önemli değil -> _  kullandım.
            
            ///hata ve veri kontrolü
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData)) ///error nil değilse bu hatayı kullan
                return
            }
        
            // Decode Response
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            }catch{
                
            }
        }
        task.resume()
    }
    
  
    //REQUEST FUNC
    //*Bu fonksiyon RMRequest türünden bir nesne alır ve bu nesneyı kullanarak URLRequest nesnesi oluşturur. */
    private func request(from rmRequest: RMRequest) -> URLRequest?{
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        
        return request
    }
}
