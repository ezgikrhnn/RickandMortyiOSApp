//
//  RMAPICacheManager .swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 25.02.2024.
//
/***
 SINIF AÇIKLAMASI:
 RMAPICacheManager sınıfı, API'den gelen yanıtları önbelleğe almak için kullanılır. Bu, aynı veriye tekrar erişim gerektiğinde, API'ye tekrar istek yapmak yerine, doğrudan önbellekten hızlı bir şekilde veriye ulaşılabilmesini sağlar. Önbelleğe alma işlemi, uygulamanın performansını önemli ölçüde artırabilir ve kullanıcı deneyimini iyileştirebilir.
 
 - CACHERESPONSE FONKSİYONNU: Bu FONK belirli bir endpoint ve url için önbelleğe alınmış yanıtı döndürür. Eğer verilen endpoint ve url için bir önbellek bulunuyorsa, bu veri Data? olarak döndürülür.
 
 - SETCACHE FONKSİYONU: Bu metod, verilen endpoint, url ve data kullanarak önbelleğe bir yanıt ekler. Verilen data, belirli bir url için endpoint önbelleğine eklenir.
 
 - SETUPCACHE FONKSİYONU: Her bir endpoint enum degeri için nscache nesnelerini başlatır ve bu nesneleri cacheDictionary sözlüğüne atar. Bu sayede, her endpoint için ayrı bir önbellek alanı oluşturulmuş olur.
 
 */

import Foundation

///Managers in memory session scoped API caches
final class RMAPICacheManager{
    
    //API URL: data
    private var cacheDictionary : [RMEndPoint: NSCache<NSString, NSData>] = [:]
    
    init(){
        setUpCache()
    }
    
    
    public func cachedResponse(for endpoint: RMEndPoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {return nil}
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndPoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {return }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    private func setUpCache(){
        RMEndPoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
            
        })
    }
}

