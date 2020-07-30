//
//  Media.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

struct Media: Codable {
    let title: String
    let year: String
    let imdbId: String
    let poster: String?
    let plot: String?
    
    // This enum MUST be called CodingKeys, if it has any over name this won't work
    // when the data gets decoded from json to this struct the CodingKeys are used
    // so keys of the json file must match this struct's properties
    // wherever it says 'title' will be transformed to 'Title' -- so the keys match 
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case poster = "Poster"
        case plot = "Plot"
    }
}
