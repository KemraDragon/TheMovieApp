//
//  MovieDetail.swift
//  TheMovieApp
//
//  Created by Sebastian Cerda Fuentes on 15-02-25.
//

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
