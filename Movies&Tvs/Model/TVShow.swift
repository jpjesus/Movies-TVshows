//
//  TVShow.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import ObjectMapper

final class TVShow: Program, Mappable {
    
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
    var originCountry: [String]?
    var airDate: String?
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        video <- map["video"]
        posterPath <- map["poster_path"]
        isForAdult <- map["adult"]
        overview <- map["overview"]
        airDate <- map["first_air_date"]
        genre <- map["genres"]
        averageVote <- map["vote_average"]
        originalTitle <- map["original_name"]
        popularity <- map["popularity"]
        originCountry <- map["origin_country"]
    }
}
