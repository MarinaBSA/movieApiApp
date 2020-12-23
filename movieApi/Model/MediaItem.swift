//
//  CellItem.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

struct MediaItem: Hashable, Codable {
    let title: String
    let plot: String?
    let year: String?
    let id: String
    // let uuid = UUID() -->
    // Immutable property will not be decoded
    // because it is declared with an initial value which cannot be overwritten
    var uuid = UUID()
    let poster: String?
    
    static func ==(lsh: MediaItem, rhs: MediaItem) -> Bool {
        return lsh.id == rhs.id
    }
}
