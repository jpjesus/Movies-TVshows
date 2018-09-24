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
    case getMovie(query: String)
    case getTvShow(query:String)
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
        case .getMovie:
            return "search/movie"
        case .getTvShow:
            return "search/tv"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params: [String: String] = [:]
        switch self {
        case .getMovie(let textToSearch):
            params ["api_key"] = apiKey
            params ["language"] = "en-US"
            params ["query"] = textToSearch
            params ["page"] = "1"
            params ["enclude_adult"] = "false"
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getTvShow(let showToSearch):
            params ["api_key"] = apiKey
            params ["language"] = "en-US"
            params ["query"] = showToSearch
            params ["page"] = "1"
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        default:
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
