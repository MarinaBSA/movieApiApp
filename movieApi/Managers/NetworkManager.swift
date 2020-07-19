//
//  NetworkManager.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import Foundation

class NetworkManager {
    static var baseURL =  "https://www.omdbapi.com/?apikey=b78d8af3"
    
    
    func getAllMedia(withTitle title: String, fromYear year: Int?,fromPage page: Int, completion: @escaping (ApiResult?, NetworkError?) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "\(NetworkManager.baseURL)&s=\(title)&page=\(page)")!
            
            let jsonDecoder = JSONDecoder()
            do {
                let movieData = try Data(contentsOf: url)
                do {
                    let result = try jsonDecoder.decode(ApiResult.self, from: movieData)
                    completion(result, nil)
                } catch {
                    print(error as Any)
                    print("Cannot decode JSON. Error: \(error.localizedDescription)")
                    completion(nil, NetworkError.jsonDecoding)
                }
            } catch {
                print("Cannot get movies' information. Error: \(error.localizedDescription)")
                completion(nil, NetworkError.internetConnection)
            }
        }
    }
    
    func getMedia(id: String, completion: @escaping (Media?, NetworkError?) -> ()) {
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
                    completion(nil, NetworkError.jsonDecoding)
                }
            } catch {
                print("Cannot get this movie's information. Error: \(error.localizedDescription)")
                completion(nil, NetworkError.internetConnection)
            }
        }
    }
    
}
