//
//  DetailViewModelTests.swift
//  MoviesTV
//
//  Created by Jesus on 9/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import XCTest
import Moya
import RxSwift
@testable import MoviesTV

class DetailViewModelTests: XCTestCase {
    
    var detailViewModel: DetailViewModel?
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        detailViewModel = DetailViewModel(type: ProgramOption.movies)
    }
    
    func test_DetailViewModel_getMovieDetail_ShouldBeEqualTo() {
        guard let detailVM = detailViewModel else {
            XCTFail("detailVM should not be nil")
            return
        }
        let movieTitle = "The Predator"
        detailVM.provider = MoyaProvider<MovieTvAPI>.init(stubClosure: MoyaProvider<MovieTvAPI>.immediatelyStub)
        let expectation =  self.expectation(description: "start fetching tv shows")
        detailVM.getMovieDetail(with: "399")
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    detailVM.rx_detail.value = response
                case .error:
                    print(Error.self)
                case .completed:
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag )
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        XCTAssertEqual(detailVM.rx_detail.value?.originalTitle, movieTitle)
    }
}
