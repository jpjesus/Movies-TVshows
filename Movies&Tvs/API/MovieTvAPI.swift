//
//  MovieTvAPI.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Moya

var apiKey: String = "84af23760314dfede939aa567bbadb40"
var apiUrl: String = "https://api.themoviedb.org/3/"

enum MovieTvAPI {
    
    case getTopMovies
    case getTopRatedMovies
    case getUpcomingMovies
    case getTopTv
    case getTopRatedTV
}

extension MovieTvAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: apiUrl) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    var path: String {
        switch self {
        case .getTopMovies:
            return "movie/popular"
        case .getTopRatedMovies:
            return "movie/top_rated"
        case .getUpcomingMovies:
            return "movie/upcoming"
        case .getTopTv:
            return "tv/popular"
        case .getTopRatedTV:
            return "tv/top_rated"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTopMovies, .getTopRatedMovies, .getUpcomingMovies,
             .getTopTv, .getTopRatedTV:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        default:
            var params: [String: String] = [:]
            params ["api_key"] = apiKey
            params ["language"] = "en-US"
            params ["page"] = "1"
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
