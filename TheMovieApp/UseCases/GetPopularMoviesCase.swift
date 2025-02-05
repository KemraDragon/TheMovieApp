//
//  GetPopularMoviesCase.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import Foundation
import RxSwift

// Estructura correcta para reflejar la API
struct MovieResponse: Decodable {
    let results: [Movie] // ✅ La API devuelve los datos dentro de "results"
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
}

class GetPopularMoviesUseCase {
    func execute() -> Observable<[Movie]> {
        return NetworkManager.shared.request(endpoint: "/movie/popular")
            .map { (response: MovieResponse) in
                return response.results // ✅ Extrae la lista de películas correctamente
            }
    }
}
