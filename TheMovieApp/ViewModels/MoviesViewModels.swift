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
    private let allMovies = BehaviorSubject<[Movie]>(value: []) // ✅ Todas las películas
    let searchQuery = PublishSubject<String>() // ✅ Consulta de búsqueda
    let filteredMovies = BehaviorSubject<[Movie]>(value: []) // ✅ Películas filtradas
    private var currentPage = 1 // ✅ Control de página
    
    func fetchMovies() {
        GetPopularMoviesUseCase(page: currentPage).execute()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    
                    print("🔍 API Response: \(movies.count) películas recibidas en página \(self.currentPage)")
                    self.allMovies.onNext(movies)
                    self.filteredMovies.onNext(movies) // ✅ Inicialmente muestra todas
                },
                onError: { error in
                    print("❌ Error fetching movies: \(error.localizedDescription)")
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
    
    // ✅ Nueva función para cargar más películas cuando se detecta el final del scroll
    func fetchMoreMovies() {
        currentPage += 1 // ✅ Avanzar a la siguiente página
        
        GetPopularMoviesUseCase(page: currentPage).execute()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { newMovies in
                    var currentMovies = try! self.allMovies.value()
                    currentMovies.append(contentsOf: newMovies) // ✅ Agregar nuevas películas a la lista existente
                    self.allMovies.onNext(currentMovies)
                    self.filteredMovies.onNext(currentMovies)
                    print("🔄 Página \(self.currentPage) cargada con \(newMovies.count) películas")
                },
                onError: { error in
                    print("❌ Error fetching more movies: \(error.localizedDescription)")
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
