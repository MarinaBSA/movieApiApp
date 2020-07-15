//
//  ApiResult.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import Foundation

struct ApiResult: Codable {
    #warning("change variables cases")
    var Search: [Media]
    var totalResults: String
    var Response: String
}
