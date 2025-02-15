//
//  MovieDetailUseCase.swift
//  TheMovieApp
//
//  Created by Sebastian Cerda Fuentes on 15-02-25.
//

import Foundation
import RxSwift
import Foundation

struct MovieDetail: Decodable {
    let title: String
    let release_date: String?
    let vote_average: Double?
    let overview: String?
    let poster_path: String?
    let genres: [Genre]?
    let runtime: Int?
    let revenue: Int?
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

class GetMovieDetailUseCase {
    private let apiKey = "d4e886f147e50185fd7a4907a8b7305e"

    func execute(movieID: Int) -> Observable<MovieDetail?> {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=es-ES"

        guard let url = URL(string: urlString) else { return Observable.just(nil) }

        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .map { response, data -> MovieDetail? in
                guard (200...299).contains(response.statusCode) else { return nil }
                return try? JSONDecoder().decode(MovieDetail.self, from: data)
            }
            .observeOn(MainScheduler.instance)
    }
}

