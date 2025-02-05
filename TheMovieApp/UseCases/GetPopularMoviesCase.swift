//
//  GetPopularMoviesCase.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import Foundation
import RxSwift

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
}

class GetPopularMoviesUseCase {

    func execute() -> Observable<[Movie]> {
        return NetworkManager.shared.request(endpoint: "/movie/popular")
    }
}
