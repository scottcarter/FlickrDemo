//
//  RecentPhotos.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import Foundation

import Alamofire


// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//


protocol RecentPhotosDelegate: class {
    
}



class RecentPhotos  {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    
    
    // MARK: - Instance Properties - Stored
    //
    
    // Our singleton (static var).   Static (and global) properties are instantiated lazily.
    //
    // Private access.  Public uses class func shared()
    //
    // Reference: https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift/
    //
    private static var sharedRecentPhotos: RecentPhotos = {
        let shared = RecentPhotos()
        
        // Configuration of singleton
        // ...
        
        return shared
    }()
    
    
    var apiKey: String?
    
    
    // MARK: - Instance Properties - Computed
    //
    
    
    
    
    // MARK: - Type Properties - Stored
    //
    // Use "static" or "class" prefix
    //
    
    
    
    // MARK: - Type Properties - Computed
    //
    // Use "static" or "class" prefix
    
    
    // ==========================================================================
    // Structs
    // ==========================================================================
    //
    // MARK: - Structs
    
    
    // Structures use to parse output from Flickr call
    
    struct FlickrResponse: Codable {
        let photos: Photos
        let stat: String
    }
    
    struct Photos: Codable {
        let photo: [PhotoDetail]
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
    }
    
    
    struct PhotoDetail: Codable {
        let farm: Int
        let server: String
        let id: String
        let secret: String
        let title: String
        let description: Description

        let isfamily: Int
        let isfriend: Int
        let ispublic: Int
        let owner: String
    }
    
    struct Description: Codable {
        let _content: String
    }
    
    
    // Structure returned to caller with photo information
    public struct FlickrResult {
        let url: String
        let title: String
        let description: String
    }
    
    
    // ==========================================================================
    // Enumerations
    // ==========================================================================
    //
    // MARK: - Enumerations
    
    enum RecentPhotosError: Error {
        case NoValue
    }

    
    // Reference:
    // https://www.flickr.com/services/api/misc.urls.html
    enum PhotoSize: String {
        case SmallSquare = "s"  // s    small square 75x75
        case Large = "q"        // q    large square 150x150
        case Thumbnail = "t"    // t    thumbnail, 100 on longest side
        case Small240 = "m"     // m    small, 240 on longest side
        case Small320 = "n"     // n    small, 320 on longest side
        case Medium500 = "-"    // -    medium, 500 on longest side
        case Medium640 = "z"    // z    medium 640, 640 on longest side
        case Medium800 = "c"    // c    medium 800, 800 on longest side
        case Large1024 = "b"    // b    large, 1024 on longest side
        case Large1600 = "h"    // h    large 1600, 1600 on longest side
        case Large2048 = "k"    // k    large 2048, 2048 on longest side
    }
    
    
    // ==========================================================================
    // Initializations
    // ==========================================================================
    //
    // MARK: - Initializations
    
    // Only private access to init via sharedADKConfig
    
    private init() {
        
    }
    
    deinit {
        
    }
    
    
    
    // ==========================================================================
    // Type methods
    // ==========================================================================
    //
    // Use static or class prefix
    //
    // Note: We include Type methods in main class, since class methods in extensions cannot be overriden currently.
    //
    // MARK: - Type methods
    
    
    class func shared() -> RecentPhotos {
        return sharedRecentPhotos
    }
    
    
    
}


// MARK: -

extension RecentPhotos {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    // None
    
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    

    // Instance must be initialized with apiKey
    public func setup(apiKey: String)  {
        
        self.apiKey = apiKey
    }
    
    
    // Public method to get an array of results.
    func photos(perPage: Int, page: Int, size:PhotoSize, completion: @escaping (Bool, [FlickrResult], Error?)->()) {
        
        // Fetch results which come in asynchronously
        let urlToRequest = requestUrl(perPage: perPage, page: page, size: size)
        
        fetch(url: urlToRequest) { (success, json, error) -> (Void) in
            
            if success == false {
                completion(false, [], error)
                return
            }
            
            guard let json = json else {
                assertionFailure("fetch returned success status with nil json")
                completion(false, [], nil)
                return
            }
            
            // Attempt to decode json
            
            let jsonData = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            var flickrResponse: FlickrResponse
            
            do {
                flickrResponse = try decoder.decode(FlickrResponse.self, from: jsonData)
            }
            catch {
                completion(false, [], error)
                return
            }
            
            let photoArr = flickrResponse.photos.photo
            
            var resultArr: [FlickrResult] = []
            
            for photo in photoArr {
                
                let urlForPhoto = self.photoUrl(farmId: photo.farm, serverId: photo.server, id: photo.id, secret: photo.secret, size: size)
                
                let result = FlickrResult(url: urlForPhoto, title: photo.title, description: photo.description._content)
                
                resultArr.append(result)
            }
            
            // Call completion handler with results gathered
            completion(true,resultArr,nil)
            
        }
        
    }
    
    
    
    
}


// MARK: -

private extension RecentPhotos {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    
    
    // Get the request URL for fetching photos.
    //
    // Reference:
    // https://www.flickr.com/services/api/flickr.photos.getRecent.html
    // https://www.flickr.com/services/api/explore/flickr.photos.getRecent
    func requestUrl(perPage: Int, page: Int, size: PhotoSize) -> String {
        
        guard let apiKey = self.apiKey else {
            assertionFailure("Api key must be set")
            return ""
        }
        
        guard perPage <= 500 else {
            assertionFailure("Maximum number of results per page request is 500")
            return ""
        }
        
        
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&format=json&nojsoncallback=1&per_page=\(perPage)&page=\(page)&extras=description"
        
        return url
        
    }
    
    
    // Get the photo URL
    //
    func photoUrl(farmId: Int, serverId: String, id: String, secret: String, size: PhotoSize) -> String {
        
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        let url = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret)_\(size.rawValue).jpg"
        
        return url
    }
    
    
    
    // Fetch Flickr recent photos
    //
    func fetch (url: String, completion: @escaping (Bool, String?, Error?)->(Void)) {
        
        // Use the default main dispatch queue for response.
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString() { response in
                
                //                print("Request: \(String(describing: response.request))")   // original url request
                //                print("Response: \(String(describing: response.response))") // http url response
                //                print("Result: \(response.result)")                         // response serialization result
                
                
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    completion(false, nil, error)
                }
                
                if let json = response.result.value {
                    completion(true, json, nil) // serialized json response
                }
                else {
                    completion(false, nil, RecentPhotosError.NoValue)
                }
                
        }
    }

    
}









