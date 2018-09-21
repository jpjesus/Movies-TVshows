//
//  Movie.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import ObjectMapper

final class Movie: Program, Mappable {
    
    var id: String?
    var video: Bool?
    var title: String?
    var posterPath: String?
    var isForAdult: Bool?
    var overview: String?
    var genreIDs: [Int]?
    var averageVote: Double?
    var popularity: Double?
    var originalTitle: String?
    var releaseDate: Date?
    
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        video <- map["video"]
        posterPath <- map["poster_path"]
        isForAdult <- map["adult"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        genreIDs <- map["genre_ids"]
        averageVote <- map["vote_average"]
        originalTitle <- map["original_title"]
        popularity <- map["popularity"]
    }
    
}
