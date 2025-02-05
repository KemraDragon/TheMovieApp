//
//  NetworkManager.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {

    static let shared = NetworkManager() // Singleton

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "d4e886f147e50185fd7a4907a8b7305e"

    private init() {} // Previene inicialización externa

    func request<T: Decodable>(endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) -> Observable<T> {
        return Observable.create { observer in
            let url = "(self.baseURL)(endpoint)?api_key=(self.apiKey)"

            AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}
