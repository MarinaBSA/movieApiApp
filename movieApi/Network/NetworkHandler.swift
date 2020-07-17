//
//  NetworkHandler.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import Foundation

class NetworkHandler {
    static var baseURL =  "https://www.omdbapi.com/?apikey=b78d8af3"
    
     func getAllMedia(withTitle title: String,fromYear year: Int?, completion: @escaping (ApiResult?) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "\(NetworkHandler.baseURL)&s=\(title)")!
            
            let jsonDecoder = JSONDecoder()
            do {
                let movieData = try Data(contentsOf: url)
                do {
                    let result = try jsonDecoder.decode(ApiResult.self, from: movieData)
                    completion(result)
                } catch {
                    print(error as Any)
                    print("Cannot decode JSON. Error: \(error.localizedDescription)")
                    completion(nil)
                }
            } catch {
                print("Cannot get movies' information. Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func getMedia(id: String, completion: @escaping (Media?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "\(NetworkHandler.baseURL)&i=\(id)")!
            
            let jsonDecoder = JSONDecoder()
            do {
                let movieData = try Data(contentsOf: url)
                do {
                    let result = try jsonDecoder.decode(Media.self, from: movieData)
                    completion(result)
                } catch {
                    print(error as Any)
                    print("Cannot decode JSON. Error: \(error.localizedDescription)")
                    completion(nil)
                }
            } catch {
                print("Cannot get this movie's information. Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
}
