//
//  ImageManager .swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 16.02.2024.

/**
 Cache geçici depolama alanıdır. Burada RMImageLoader sınıfı, indirilen resim verilerini NSCache nesnesinde saklayarak aynı URL'ye sahip resimlerin tekrar tekrar indirilmesini önler.  Bu cache, anahtar-değer çiftleri şeklinde veri saklar.
 
 DownloadImage fonksiyonu çağırıldıgında ilk olarak verilen URL'nin string hali (url.absoluteString) cachede anahtar olarak aranır. Eğer bu anahtar ile eşleşen veri varsa (yani daha önceden indirilmiş resim verisi), bu veri doğrudan cacheden alınır ve ağ çağrısı yapmadan completion handler üzerinden döndürülür.
 
 Bu mekanizma sayesinde, uygulama aynı resimleri birden fazla kez indirmek yerine, daha önce indirilmiş ve cache'de saklanmış resimleri kullanır. Bu da hem hızlı veri erişimi sağlar hem de ağ kullanımını ve kaynak tüketimini azaltır.
 */

import Foundation

final class RMImageLoader{
    
    static let shared = RMImageLoader()
    //cache oluşturma
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init(){}
    
    /**
     DOWNLOAD IMAGE FUNC = url ile resim içeriği alma
        parameters: url= source url, completion= CallBack
        bu fonksiyonu cellviewmodelde kullanacağım.*/
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void){
        //cache kontrolü
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key){
            print("Reading fromcache: \(key)")
            completion(.success(data as Data)) ///NSData == Data ya da NSString == String diyebiliriz ikisi neredeyse aynı şeylerdir
            return
        }
        
        //cache veri ekleme
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with:  url){ [weak self] data, _, error in
            
            guard let data = data, error == nil else{
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
          
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}

