//
//  NetworkError.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 18.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

enum NetworkError: String {
    case jsonDecoding = "There seems to be no media under the searched keyword. Try another one or check for typos. "
    case internetConnection = "There is something wrong with your internet connection. Try later again."
}
