//
//  ViewController.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyHelpers
import SwiftSpinner

struct ProgramListSection {
    var header: String
    var items: [Item]
}

extension ProgramListSection: SectionModelType {
    typealias Item = Program
    
    init(original: ProgramListSection, items: [Item]) {
        self = original
        self.items =  items
    }
}

class ProgamListVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.placeholder = "Search movie or tv show"
            searchTextField.autocorrectionType = .no
            searchTextField.clearButtonMode = .whileEditing
            searchTextField.returnKeyType = .search
        }
    }
    @IBOutlet weak var menuBar: UITabBar!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var progamCollectionView: UICollectionView!{
        didSet {
            progamCollectionView.showsVerticalScrollIndicator = false
            progamCollectionView <= ProgramListCell.self
        }
    }
    enum Route: String {
        case programDetail
    }
    
    private  var segmentedControl: UISegmentedControl!
    
    private var disposeBag = DisposeBag()
    private var viewModel: ProgramsViewModel = ProgramsViewModel()
    private var dataSource:RxCollectionViewSectionedReloadDataSource<ProgramListSection>?
    fileprivate let movieOptions:[String] = ["Popular", "Top Rated", "Upcoming"]
    fileprivate let tvOptions:[String] = ["Popular", "Top Rated"]
    fileprivate var router: RouterProgram!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()
        prepareUI()
        router = RouterProgram(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .semaphoreRed()
    }
    
    func rxBind() {
        SwiftSpinner.show("Loading movies ...")
        self.viewModel.getMovieList(by: ProgramType.popularMovies)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    self?.viewModel.rx_MovieList.value = response
                    self?.viewModel.saveMoviesIncache(list: response)
                case .error:
                    self?.retreiveMoviesFromCache()
                case .completed:
                    SwiftSpinner.hide()
                }
            }).disposed(by: self.viewModel.disposeBag)
        
        dataSource = createDataSource()
        setMovieCollection()
        
        self.progamCollectionView.rx
            .modelSelected(Movie.self)
            .subscribe({ [unowned self] program in
                self.router.route(to: Route.programDetail.rawValue, from: self, parameters: program.element)
            }).disposed(by: disposeBag)
        
        self.searchTextField.rx
            .text
            .orEmpty
            .do(onNext: { [weak self] text in
                if text.count >= 3 {
                    self?.onlineSearch()
                }
            }).bind(to: self.viewModel.rx_onlineSearch)
            .disposed(by: disposeBag)
    }
    
    private func prepareUI() {
        menuBar.selectedItem =  menuBar.items?[0]
        self.viewModel.optionType = .movies
        menuBar.delegate = self
        addSegmentedControlToNavigation(type: .movies)

    }
    
    private func setMovieCollection() {
        guard let dataSource = self.dataSource else { return }
        self.progamCollectionView.delegate = nil
        self.progamCollectionView.dataSource = nil
        self.viewModel.rx_MovieList.asObservable()
            .map(self.viewModel.setMovies)
            .bind(to: self.progamCollectionView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
        
        self.progamCollectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.progamCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    private func setTvCollection() {
        guard let dataSource = self.dataSource else { return }
        self.progamCollectionView.delegate = nil
        self.progamCollectionView.dataSource = nil
        self.viewModel.rx_TvList.asObservable()
            .map(self.viewModel.setTvShows)
            .bind(to: self.progamCollectionView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
        
        self.progamCollectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.progamCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ProgramListSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProgramListSection>(configureCell:{ (dataSource: CollectionViewSectionedDataSource<ProgramListSection>, collectionView: UICollectionView, indexPath: IndexPath, item: Program) in
            let cell: ProgramListCell = collectionView.cellForClass(indexPath)
            cell.buildCell(for: item)
            return cell
        })
        return dataSource
    }
    
    private func onlineSearch() {
        if self.viewModel.optionType == .movies {
            self.viewModel.getMovieList(by: .onlineSearchMovie)
                .subscribe({ [weak self] event in
                    switch event {
                    case let .next(response):
                        self?.viewModel.rx_MovieList.value = response
                    case .error:
                        self?.retreiveMoviesFromCache()
                    case .completed:
                        SwiftSpinner.hide()
                    }
                }).disposed(by: disposeBag)
            self.setMovieCollection()
        } else {
            self.viewModel.getTvList(by: .onlineSearchTvShow)
                .subscribe({ [weak self] event in
                    switch event {
                    case let .next(response):
                        self?.viewModel.rx_TvList.value = response
                    case .error:
                        self?.retreiveMoviesFromCache()
                    case .completed:
                        SwiftSpinner.hide()
                    }
                }).disposed(by: disposeBag)
            self.setTvCollection()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProgamListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.contentSize.width, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5.0, left: 0, bottom:5.0 , right:0)
    }
}

extension ProgamListVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (menuBar.items)?[0]{
            self.viewModel.optionType = .movies
            addSegmentedControlToNavigation(type: .movies)
            segmentChanged()
        } else {
            self.viewModel.optionType = .tvShow
            addSegmentedControlToNavigation(type: .tvShow)
            segmentChanged()
            self.progamCollectionView.rx
                .modelSelected(TVShow.self)
                .subscribe({ [unowned self] program in
                    self.router.route(to: Route.programDetail.rawValue, from: self, parameters: program.element)
                }).disposed(by: disposeBag)
        }
    }
}

// MARK: - Alerts
extension ProgamListVC {
    
    func retreiveMoviesFromCache() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.viewModel.retreiveMoviesFromCache(from: .popularMovies)
        case 1:
            self.viewModel.retreiveMoviesFromCache(from: .topRatedMovies)
        default:
            self.viewModel.retreiveMoviesFromCache(from: .upcomingMovies)
        }
        SwiftSpinner.hide()
        if self.viewModel.rx_MovieList.value == nil {
            self.showOfflineAlert()
        }
    }
    
    func showOfflineAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("You are offline", comment: "You are offline"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        if let navigation = self.navigationController?.visibleViewController {
            if !(navigation.isKind(of: UIAlertController.self)) {
                OperationQueue.main.addOperation {
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - SegmentedControl
extension ProgamListVC {
    
    func addSegmentedControlToNavigation(type:ProgramOption) {
        if let _ = segmentedControl {
            segmentedControl.removeAllSegments()
        }
        switch type {
        case .movies:
            segmentedControl = UISegmentedControl(items: movieOptions)
            buildSegmentedControl(segment: segmentedControl)
        default:
            segmentedControl = UISegmentedControl(items: tvOptions)
            buildSegmentedControl(segment: segmentedControl)
            navigationItem.titleView = segmentedControl
        }
    }
    
    private func buildSegmentedControl(segment: UISegmentedControl) {
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = .semaphoreRed()
        navigationItem.titleView = segmentedControl
    }
    
    @objc private func segmentChanged() {
        if self.viewModel.optionType == .movies {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                self.viewModel.getMovieList(by: .popularMovies)
                    .subscribe({ [weak self] event in
                        switch event {
                        case let .next(response):
                            self?.viewModel.rx_MovieList.value = response
                            self?.viewModel.saveMoviesIncache(list: response)
                        case .error:
                            self?.retreiveMoviesFromCache()
                        case .completed:
                            SwiftSpinner.hide()
                        }
                    }).disposed(by: disposeBag)
            case 1:
                self.viewModel.getMovieList(by: .topRatedMovies)
                    .subscribe({ [weak self] event in
                        switch event {
                        case let .next(response):
                            self?.viewModel.rx_MovieList.value = response
                            self?.viewModel.saveMoviesIncache(list: response)
                        case .error:
                            self?.retreiveMoviesFromCache()
                        case .completed:
                            SwiftSpinner.hide()
                        }
                    }).disposed(by: disposeBag)
            default:
                self.viewModel.getMovieList(by: .upcomingMovies)
                    .subscribe({ [weak self] event in
                        switch event {
                        case let .next(response):
                            self?.viewModel.rx_MovieList.value = response
                            self?.viewModel.saveMoviesIncache(list: response)
                        case .error:
                            self?.retreiveMoviesFromCache()
                        case .completed:
                            SwiftSpinner.hide()
                        }
                    }).disposed(by: disposeBag)
            }
            self.setMovieCollection()
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                self.viewModel.getTvList(by: .popularTvShows)
                    .subscribe({ [weak self] event in
                        switch event {
                        case let .next(response):
                            self?.viewModel.rx_TvList.value = response
                            self?.viewModel.saveTvShowsIncache(list: response)
                        case .error:
                            self?.retreiveMoviesFromCache()
                        case .completed:
                            SwiftSpinner.hide()
                        }
                    }).disposed(by: disposeBag)
            case 1:
                self.viewModel.getTvList(by: .topRateTvShows)
                    .subscribe({ [weak self] event in
                        switch event {
                        case let .next(response):
                            self?.viewModel.rx_TvList.value = response
                            self?.viewModel.saveTvShowsIncache(list: response)
                        case .error:
                            self?.retreiveMoviesFromCache()
                        case .completed:
                            SwiftSpinner.hide()
                        }
                    }).disposed(by: disposeBag)
            default:
                return
            }
            self.setTvCollection()
        }
    }
}
