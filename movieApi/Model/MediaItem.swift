//
//  CellItem.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import Foundation

struct MediaItem: Hashable {
    let title: String
    let plot: String?
    let year: String?
    let id: String
    let uuid = UUID()
    //let poster: UIImage
}
