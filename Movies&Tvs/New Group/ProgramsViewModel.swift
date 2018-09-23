//
//  ProgramsViewModel.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper

enum ProgramType {
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    case popularTvShows
    case topRateTvShows
}

class ProgramsViewModel {
    var disposeBag = DisposeBag()
    var provider = MoyaProvider<MovieTvAPI>()
    var rx_ProgramList = Variable<MovieList?>(nil)
    var programs: MovieList?
    
    func getMovieList(by type: ProgramType) -> Observable<MovieList> {
        switch type {
        case .popularMovies:
            return provider.rx
                .request(MovieTvAPI.getTopMovies)
                .debug()
                .asObservable()
                .mapObject(MovieList.self)
        case .topRatedMovies:
            return provider.rx
                .request(MovieTvAPI.getTopRatedMovies)
                .debug()
                .asObservable()
                .mapObject(MovieList.self)
        case .upcomingMovies:
            return provider.rx
                .request(MovieTvAPI.getUpcomingMovies)
                .debug()
                .asObservable()
                .mapObject(MovieList.self)
        default:
            return Observable.error(RxError.noElements)
        }
    }
    
    func getTvList(by type: ProgramType) -> Observable<TVList> {
        
        switch type {
        case .popularTvShows:
            return provider.rx
                .request(MovieTvAPI.getTopTv)
                .debug()
                .asObservable()
                .mapObject(TVList.self)
        case .topRateTvShows:
            return provider.rx
                .request(MovieTvAPI.getTopRatedTV)
                .debug()
                .asObservable()
                .mapObject(TVList.self)
        default:
            return Observable.error(RxError.noElements)
        }
    }
    
    
    func setMovies(movies: MovieList?) -> [ProgramListSection] {
        var results:[ProgramListSection] = []
        if let movies = movies?.list  {
            results.append(ProgramListSection(header: "Popular Movies", items: movies))
            return results
        }
        return results
    }
    
    
    init() {
    }
}
