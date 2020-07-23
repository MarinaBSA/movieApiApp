//
//  NetworkError.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 18.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

enum CustomError: String, Error {
    case searchNotFound = "There seems to be no media under the searched keyword. Try another one or check for typos. "
    case internetConnection = "There is something wrong with your internet connection. Try later again."
    case favoritesEncoding = "Could not save this media as favorite. Try later again or contact us."
    case allFavoritesEncoding = "Could not save all favorites. Try later again or contact us."
    case getMedia = "Cannot find this media for some reason. Try later again."
    case showFavorites = "Could show your favorites. Sorry, try later again."
    case alreadyFavorite = "This media is already set as one of your favorites."
    case updateFavorites = "Could not update your favorites. Try later again or contact us."
}
