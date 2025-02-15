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

    private var watchedMovies: [Movie] = []
    private let watchedMoviesKey = "watchedMovies" // Clave para guardar en UserDefaults
    private let disposeBag = DisposeBag()
    let allMovies = BehaviorSubject<[Movie]>(value: []) // ✅ Todas las películas
    let searchQuery = PublishSubject<String>() // ✅ Consulta de búsqueda
    let filteredMovies = BehaviorSubject<[Movie]>(value: []) // ✅ Películas filtradas
    private var currentPage = 1 // ✅ Control de página

    init() {
        loadWatchedMovies() // ✅ Cargar películas vistas al iniciar
    }

    // ✅ Guardar la lista de películas vistas en UserDefaults
    private func saveWatchedMovies() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(watchedMovies) {
            UserDefaults.standard.set(encoded, forKey: watchedMoviesKey)
        }
    }

    // ✅ Cargar la lista de películas vistas desde UserDefaults
    private func loadWatchedMovies() {
        if let savedData = UserDefaults.standard.data(forKey: watchedMoviesKey) {
            let decoder = JSONDecoder()
            if let loadedMovies = try? decoder.decode([Movie].self, from: savedData) {
                watchedMovies = loadedMovies
            }
        }
    }

    // ✅ Verifica si una película ha sido marcada como vista
    func isWatched(movie: Movie) -> Bool {
        return watchedMovies.contains { $0.id == movie.id }
    }

    // ✅ Alternar el estado de una película (vista/no vista) y persistir el cambio
    func toggleWatchedState(for index: Int) {
        let currentMovies = try? allMovies.value() // Obtener lista actual de películas
        guard let movies = currentMovies, movies.indices.contains(index) else { return }

        let movie = movies[index]

        if let watchedIndex = watchedMovies.firstIndex(where: { $0.id == movie.id }) {
            watchedMovies.remove(at: watchedIndex) // Si ya estaba, la quitamos
        } else {
            watchedMovies.append(movie) // Si no estaba, la agregamos
        }

        saveWatchedMovies() // ✅ Guardar cambios en la memoria
        allMovies.onNext(movies) // ✅ Actualizar la lista de películas
    }

    // ✅ Obtiene la lista de películas inicial
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

    // ✅ Cargar más películas cuando el usuario llega al final del scroll
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
