//
//  FavoritesManager.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 20.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class FavoritesManager {
    static let defaults = UserDefaults.standard
    static let key = "favorites"
    
    static func getFavorites() -> Result<[MediaItem]?, CustomError> {
        let jsonDecoder = JSONDecoder()
    
        if let data = FavoritesManager.defaults.object(forKey: FavoritesManager.key) as? Data {
            do {
                let media = try jsonDecoder.decode([MediaItem].self, from: data)
                return .success(media)
            } catch {
                return .failure(.showFavorites)
            }
        }
        return .success(nil)   // no favorites
    }
    
    
    static func setFavorite(media: MediaItem, completion: @escaping (CustomError?) -> Void) {
        let favorites = FavoritesManager.getFavorites()
        let jsonEncoder = JSONEncoder()
        
        switch favorites {
            case .success(let favorites):
                if var newFavorites = favorites  {
                    guard !newFavorites.contains(media) else {
                        completion(.alreadyFavorite)
                        return
                    }
                    newFavorites.append(media)
                    do {
                        let data = try jsonEncoder.encode(newFavorites)
                        FavoritesManager.defaults.set(data, forKey: FavoritesManager.key)
                        completion(nil)
                    } catch {
                        completion(.allFavoritesEncoding)
                    }
                    return
                }
            
                // no favorites yet -> favorites is nil from getFavorites()
                do {
                    var newFavorites = [MediaItem]()
                    newFavorites.append(media)
                    let data = try jsonEncoder.encode(newFavorites)
                    FavoritesManager.defaults.set(data, forKey: FavoritesManager.key)
                    completion(nil)
                } catch {
                    completion(.allFavoritesEncoding)
                }
            case .failure(let error):
                completion(error)
        }
    }
    
    static func isFavorite(media: MediaItem) -> Bool? {
        let favorites = FavoritesManager.getFavorites()
        switch favorites {
            case .success(let favorites):
                guard let passedFavorites = favorites else { return false }      // no favorites yet
                return !passedFavorites.isEmpty && passedFavorites.contains(media)
            case .failure(_):
                return nil
        }
    }
}
