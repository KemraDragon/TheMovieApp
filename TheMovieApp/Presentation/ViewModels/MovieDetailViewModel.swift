//
//  DetailViewModel.swift
//  TheMovieApp
//
//  Created by Sebastian Cerda Fuentes on 15-02-25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    private let disposeBag = DisposeBag()
    private let getMovieDetailUseCase = GetMovieDetailUseCase()

    let title = BehaviorRelay<String>(value: "")
    let releaseDate = BehaviorRelay<String>(value: "No disponible")
    let rating = BehaviorRelay<String>(value: "0.0")
    let movieID = BehaviorRelay<String>(value: "")
    let posterURL = BehaviorRelay<URL?>(value: nil)
    let overview = BehaviorRelay<String>(value: "No disponible")
    let genres = BehaviorRelay<String>(value: "No disponible")
    let runtime = BehaviorRelay<String>(value: "No disponible")
    let revenue = BehaviorRelay<String>(value: "No disponible")

    init(movieID: Int) {
        self.movieID.accept("ID: \(movieID)")
        fetchMovieDetails(movieID: movieID)
    }

    private func fetchMovieDetails(movieID: Int) {
        getMovieDetailUseCase.execute(movieID: movieID)
            .subscribe(onNext: { [weak self] movieDetail in
                guard let self = self, let detail = movieDetail else { return }

                self.title.accept(detail.title)
                self.releaseDate.accept("Fecha de lanzamiento: \(detail.release_date ?? "No disponible")")
                self.rating.accept("Rating: \(detail.vote_average ?? 0.0)")
                self.overview.accept(detail.overview ?? "No disponible")
                self.runtime.accept("Duración: \(detail.runtime ?? 0) minutos")
                self.revenue.accept("Recaudación: $\(detail.revenue ?? 0) USD")

                if let posterPath = detail.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    self.posterURL.accept(url)
                }

                if let genres = detail.genres?.map({ $0.name }).joined(separator: ", ") {
                    self.genres.accept("Géneros: \(genres)")
                }
            })
            .disposed(by: disposeBag)
    }
}

