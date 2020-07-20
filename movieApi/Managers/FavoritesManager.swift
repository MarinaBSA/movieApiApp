//
//  FavoritesManager.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 20.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class FavoritesManager {
    static let defaults = UserDefaults()
    
    func getFavorites() -> [MediaItem]? {
        
        return nil
    }
    
    
    func setFavorite(media: MediaItem) {
        FavoritesManager.defaults.set(media, forKey: media.id)
    }
    
    func isFavorite(media: MediaItem) -> Bool {
        return false
    }
}
