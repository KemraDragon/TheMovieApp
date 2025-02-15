//
//  GetPopularMoviesCase.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import Foundation
import RxSwift

class GetPopularMoviesUseCase {
    
    private let page: Int // ✅ Se define la página como parámetro
    
    init(page: Int) { // ✅ Se recibe la página en el inicializador
        self.page = page
    }
    
    func execute() -> Observable<[Movie]> {
        let endpoint = "/movie/popular?api_key=d4e886f147e50185fd7a4907a8b7305e&page=\(page)" // ✅ URL corregida con paginación
        return NetworkManager.shared.request(endpoint: endpoint)
            .map { (response: MovieResponse) in
                return response.results // ✅ Extrae la lista de películas correctamente
            }
    }
}
