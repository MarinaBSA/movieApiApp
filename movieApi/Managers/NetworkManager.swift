//
//  NetworkManager.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class NetworkManager {
    static var baseURL =  "https://www.omdbapi.com/?apikey=b78d8af3"
    
    static func getAllMedia(withTitle title: String, fromYear year: Int?,fromPage page: Int, completion: @escaping (ApiResult?, CustomError?) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            let titleWithoutSpaces = title.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string: "\(NetworkManager.baseURL)&s=\(titleWithoutSpaces)&page=\(page)")!
            
            let jsonDecoder = JSONDecoder()
            do {
                let movieData = try Data(contentsOf: url)
                do {
                    let result = try jsonDecoder.decode(ApiResult.self, from: movieData)
                    completion(result, nil)
                } catch {
                    print(error as Any)
                    print("Cannot decode JSON. Error: \(error.localizedDescription)")
                    completion(nil, CustomError.searchNotFound)
                }
            } catch {
                print("Cannot get movies' information. Error: \(error.localizedDescription)")
                completion(nil, CustomError.internetConnection)
            }
        }
    }
    
    static func getMedia(id: String, completion: @escaping (Media?, CustomError?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "\(NetworkManager.baseURL)&i=\(id)")!
            
            let jsonDecoder = JSONDecoder()
            do {
                let movieData = try Data(contentsOf: url)
                do {
                    let result = try jsonDecoder.decode(Media.self, from: movieData)
                    completion(result, nil)
                } catch {
                    print(error as Any)
                    print("Cannot decode JSON. Error: \(error.localizedDescription)")
                    completion(nil, CustomError.getMedia)
                }
            } catch {
                print("Cannot get this movie's information. Error: \(error.localizedDescription)")
                completion(nil, CustomError.internetConnection)
            }
        }
    }
    
    
    static func getImage(mediaURL: String?, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var image = UIImage()
            if let passedURL = mediaURL {
                if let cachedImage = SearchViewController.imageCache.object(forKey: NSString(string: passedURL)) {
                    // image already cached -- get it from the cache
                    image = cachedImage
                }
                // image not cached -- cache it
                if let imageURL = URL(string: passedURL) {
                    do {
                        let data = try Data(contentsOf: imageURL)
                        if let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: compressedImageData) {
                            SearchViewController.imageCache.setObject(compressedImage, forKey: NSString(string: passedURL))
                            image = UIImage(data: compressedImageData)!
                        }
                    } catch {
                        print("Cannot get image from url. Error: \(error.localizedDescription)")
                        image = UIImage(systemName: Images.placeholder.rawValue)!
                    }
                }
            }
            completion(image)
        }
    }
    
}
