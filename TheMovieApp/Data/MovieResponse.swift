//
//  MovieResponse.swift
//  TheMovieApp
//
//  Created by Sebastian Cerda Fuentes on 15-02-25.
//

import Foundation
// Estructura correcta para reflejar la API
struct MovieResponse: Codable {
    let results: [Movie] // ✅ La API devuelve los datos dentro de "results"
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
}
