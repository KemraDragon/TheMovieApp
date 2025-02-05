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

    private let baseURL = "https://api.themoviedb.org/3" // ✅ Base de la API
    private let apiKey = "d4e886f147e50185fd7a4907a8b7305e" // ✅ Tu API Key

    private init() {} // Previene inicialización externa

    func request<T: Decodable>(endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) -> Observable<T> {
        return Observable.create { observer in
            let url = "\(self.baseURL)\(endpoint)" // ✅ Se construye la URL base + endpoint

            var params = parameters ?? [:]
            params["api_key"] = self.apiKey // ✅ Se añade la API Key como parámetro

            print("🌍 URL Request: \(url)?api_key=\(self.apiKey)") // ✅ Verifica la URL generada

            AF.request(url, method: method, parameters: params, encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        if let data = response.data,
                           let jsonString = String(data: data, encoding: .utf8) {
                            print("❌ API Error: \(jsonString)") // ✅ Muestra el JSON de error de la API
                        } else {
                            print("❌ API Error: (error.localizedDescription)")
                        }
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}
