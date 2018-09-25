//
//  DetailViewModel.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper

class DetailViewModel {
    
    var rx_detail = Variable<Program?>(nil)
    var rx_video = Variable<VideoList?>(nil)
    var provider = MoyaProvider<MovieTvAPI>()
    var optionType: ProgramOption?
    
    func getMovieDetail(with id: String) -> Observable<Movie> {
        return provider.rx
            .request(MovieTvAPI.getMovieDetail(id: id))
            .debug()
            .asObservable()
            .mapObject(Movie.self)
    }
    
    func getTvShowDetail(with id: String) -> Observable<TVShow> {
        return provider.rx
            .request(MovieTvAPI.getTvShowDetail(id: id))
            .debug()
            .asObservable()
            .mapObject(TVShow.self)
    }
    
    func getMovieTvTrailer(with id: String) -> Observable<VideoList> {
        if optionType == .movies {
            return provider.rx
                .request(MovieTvAPI.getMovieTrailer(id: id))
                .asObservable()
                .mapObject(VideoList.self)
        } else {
            return provider.rx
                .request(MovieTvAPI.getTvTrailer(id: id))
                .asObservable()
                .mapObject(VideoList.self)
        }
    }
    
    init(type:ProgramOption) {
        self.optionType = type
    }
}
