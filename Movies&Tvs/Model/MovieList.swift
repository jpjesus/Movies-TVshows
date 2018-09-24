//
//  ProgramList.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieList: Mappable {
    
    var list: [Movie]?
    
     required init?(map: Map) {
    }
     init () {
    }
    
    func mapping(map: Map) {
        list <- map["results"]
    }
}
