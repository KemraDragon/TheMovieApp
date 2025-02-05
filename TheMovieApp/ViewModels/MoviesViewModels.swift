//
//  MoviesViewModels.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesViewModel {

    private let disposeBag = DisposeBag()
    private let allMovies = BehaviorSubject<[Movie]>(value: []) // Todas las películas
    let searchQuery = PublishSubject<String>() // Consulta de búsqueda
    let filteredMovies = BehaviorSubject<[Movie]>(value: []) // Películas filtradas

    func fetchMovies() {
        GetPopularMoviesUseCase().execute()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.allMovies.onNext(movies)
                    self.filteredMovies.onNext(movies) // Inicialmente muestra todas las películas
                },
                onError: { error in
                    print("❌ Error fetching movies: (error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)

        searchQuery
            .withLatestFrom(allMovies) { query, movies in
                return query.isEmpty ? movies : movies.filter { $0.title.lowercased().contains(query.lowercased()) }
            }
            .bind(to: filteredMovies)
            .disposed(by: disposeBag)
    }
}
