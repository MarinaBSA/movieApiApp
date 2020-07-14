//
//  ViewController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let baseURL = "https://www.omdbapi.com/?apikey=b78d8af3"
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let result = getMovies(title: "Monkey", year: nil) {
            showMovies(movies: result.Search)
        }
    }
    
    private func getMovies(title: String, year: Int?) -> ApiResult? {
        let url = URL(string: "\(baseURL)&s=\(title)")!
    
        let jsonDecoder = JSONDecoder()
        do {
            let movieData = try Data(contentsOf: url)
            do {
                let result = try jsonDecoder.decode(ApiResult.self, from: movieData)
                return result
            } catch {
                print(error as Any)
                print("Cannot decode JSON. Error: \(error.localizedDescription)")
            }
        } catch {
            print("Cannot get this movie's information. Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func showMovies(movies: [Movie]) {
        for movie in movies {
            print("Title: \(movie.Title)")
            if let moviesYear = movie.Year {
                print("Year: \(moviesYear)")
            }
            print("ID: \(movie.imdbID)")
            print("----------------------")
        }
    }


}

