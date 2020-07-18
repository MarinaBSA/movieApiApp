//
//  NetworkError.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 18.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

enum NetworkError: String {
    case jsonDecoding = "There seems to be no media under the searched keyword. Try another one or check for typos. "
    case movieInformation = "There seems to be something odd with your internet connection. Verify if everything is alright or try later again."
}
