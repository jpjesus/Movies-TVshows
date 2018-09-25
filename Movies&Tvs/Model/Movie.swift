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
    
    var id: Int?
    var video: Bool?
    var title: String?
    var posterPath: String?
    var isForAdult: Bool?
    var overview: String?
    var genre: [Genre]?
    var averageVote: String?
    var popularity: Double?
    var originalTitle: String?
    var releaseDate: String?
    var tagline:String?
    
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        video <- map["video"]
        posterPath <- map["poster_path"]
        isForAdult <- map["adult"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        genre <- map["genres"]
        averageVote <- map["vote_average"]
        originalTitle <- map["original_title"]
        popularity <- map["popularity"]
        tagline <- map["tagline"]
    }
    
}


struct Genre: Mappable {
    var id: Int?
    var name: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
