//
//  TVList.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/22/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import ObjectMapper

class TVList: Mappable {
    
    var list: [TVShow]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        list <- map["results"]
    }
}
