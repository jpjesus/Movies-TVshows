//
//  Video.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import ObjectMapper

let youtubeLink = "https://www.youtube.com/watch?v="

struct VideoList: Mappable {
    
    var list:[Video]?
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        list <- map["results"]
    }
}

struct Video: Mappable {
    
    var videoPath:String?
    var type:String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        videoPath <- map["key"]
        type <- map["type"]
    }
}
