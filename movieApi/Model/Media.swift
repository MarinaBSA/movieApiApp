//
//  Media.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

struct Media: Codable {
    #warning("change variables cases")
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String?
    let Plot: String?
}
