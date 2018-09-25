//
//  ProgramsViewModelTests.swift
//  Movies&TvsTests
//
//  Created by Jesus on 9/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Moya
@testable import MoviesTV

class ProgramsViewModelTests: XCTestCase {
    
    var programsViewModel: ProgramsViewModel?
    
    override func setUp() {
        super.setUp()
        programsViewModel =  ProgramsViewModel()
    }
    
    func test_ProgramsViewModel_getMovieList_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching movies")
        programsVM.getMovieList(by: ProgramType.popularMovies)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    programsVM.rx_MovieList.value = response
                    programsVM.saveMoviesIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        XCTAssertEqual(programsVM.rx_MovieList.value?.list?.count, 20)
    }
    
    func test_ProgramsViewModel_getTvList_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
        programsVM.getTvList(by: ProgramType.popularTvShows)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    programsVM.rx_TvList.value = response
                    programsVM.saveTvShowsIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        XCTAssertEqual(programsVM.rx_TvList.value?.list?.count, 20)
    }
    
    func test_ProgramsViewModel_retreiveTvShowsFromCache_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
        var testList:TVList?
        programsVM.getTvList(by: ProgramType.popularTvShows)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    testList = response
                    programsVM.saveTvShowsIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        programsVM.retreiveTvShowsFromCache(from: ProgramType.popularTvShows)
        XCTAssertEqual(programsVM.rx_TvList.value?.list?.count,testList?.list?.count)
    }
    
    func test_ProgramsViewModel_retreiveMoviesFromCache_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
         var testList:MovieList?
        programsVM.getMovieList(by: ProgramType.popularMovies)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    testList = response
                    programsVM.saveMoviesIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        programsVM.retreiveMoviesFromCache(from: ProgramType.popularMovies)
        XCTAssertEqual(programsVM.rx_MovieList.value?.list?.count, testList?.list?.count)
    }
    
    func test_ProgramsViewModel_setMovies_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
        programsVM.getMovieList(by: ProgramType.popularMovies)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    programsVM.rx_MovieList.value = response
                    programsVM.saveMoviesIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        let section = programsVM.setMovies(movies: programsVM.rx_MovieList.value)
        XCTAssertGreaterThan(section.count, 0)
    }
    
    func test_ProgramsViewModel_setTvShows_ShouldBeEqualTo() {
        guard let programsVM = programsViewModel else {
            XCTFail("programsVM should not be nil")
            return
        }
        programsVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
        programsVM.getTvList(by: ProgramType.popularTvShows)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    programsVM.rx_TvList.value = response
                    programsVM.saveTvShowsIncache(list: response)
                    
                case .error:
                    print("fail")
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: programsVM.disposeBag)
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        let section = programsVM.setTvShows(shows: programsVM.rx_TvList.value)
        XCTAssertGreaterThan(section.count, 0)
    }
}
