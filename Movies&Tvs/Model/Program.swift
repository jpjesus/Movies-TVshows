//
//  Program.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation

protocol Program {
    var id: Int? {get set}
    var video: Bool? {get set}
    var title: String? {get set}
    var posterPath: String? {get set}
    var isForAdult: Bool? {get set}
    var overview: String? {get set}
    var genre: [Genre]? {get set}
    var averageVote: String? {get set}
    var popularity: Double? {get set}
    var originalTitle: String? {get set}
}
