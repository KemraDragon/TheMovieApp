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
    let movies = PublishSubject<[Movie]>()

    func fetchMovies() {
        GetPopularMoviesUseCase().execute()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.movies.onNext(movies)
                },
                onError: { error in
                    print("Error fetching movies: (error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}
