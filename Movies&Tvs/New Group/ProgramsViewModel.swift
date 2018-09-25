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


class ProgramsViewModel {
    
    var disposeBag = DisposeBag()
    var provider = MoyaProvider<MovieTvAPI>()
    var rx_MovieList = Variable<MovieList?>(nil)
    var rx_TvList = Variable<TVList?>(nil)
    var rx_onlineSearch = Variable("")
    var optionType: ProgramOption?
    
    private var programType: ProgramType?
    private var movieCache: NSCache <AnyObject, MovieList>?
    private var tvCache: NSCache <AnyObject, TVList>?
    private var tvList: TVList?
    private var movieList: MovieList?
    private let movieCacheName = "MovieCache"
    private let tvCacheName = "TvCache"
    
    init() {
    }
    
    func getMovieList(by type: ProgramType) -> Observable<MovieList> {
        
        programType = type
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
        case .onlineSearchMovie:
              return provider.rx
                   .request(MovieTvAPI.getMovie(query: rx_onlineSearch.value))
                   .debug()
                   .asObservable()
                   .mapObject(MovieList.self)
        default:
            return Observable.error(RxError.noElements)
        }
    }
    
    func getTvList(by type: ProgramType) -> Observable<TVList> {
        
        programType = type
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
        case .onlineSearchTvShow:
            return provider.rx
                .request(MovieTvAPI.getTvShow(query: rx_onlineSearch.value))
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
    
    func setTvShows(shows: TVList?) -> [ProgramListSection] {
        var results:[ProgramListSection] = []
        if let shows = shows?.list  {
            results.append(ProgramListSection(header: "", items: shows))
            return results
        }
        return results
    }
}

extension ProgramsViewModel {
    
    func saveMoviesIncache(list: MovieList) {
        movieCache = NSCache<AnyObject, MovieList> ()
        movieCache?.setObject(list, forKey: movieCacheName+String(describing: programType) as AnyObject)
    }
    
    func retreiveMoviesFromCache(from type:ProgramType){
        
        if let cache = movieCache,
            let cachedVersion = cache.object(forKey: movieCacheName+String(describing: programType) as AnyObject) {
            self.rx_MovieList.value = cachedVersion
        } else {
            self.rx_MovieList.value = nil
        }
    }
    
    func saveTvShowsIncache(list: TVList) {
        tvCache = NSCache<AnyObject, TVList> ()
        tvCache?.setObject(list, forKey: tvCacheName+String(describing: programType) as AnyObject)
    }
    
    func retreiveTvShowsFromCache(from type:ProgramType){
        
        if let cache = tvCache,
            let cachedVersion = cache.object(forKey: tvCacheName+String(describing: programType) as AnyObject) {
            self.rx_TvList.value = cachedVersion
        } else {
            self.rx_TvList.value = nil
        }
    }
}
