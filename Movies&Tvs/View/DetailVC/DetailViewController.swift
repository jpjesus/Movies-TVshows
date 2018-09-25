//
//  DetailView.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/23/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SwiftSpinner
import youtube_ios_player_helper

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .titleFont()
            titleLabel.isHidden = true
        }
    }
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.font = .dateFont()
            genreLabel.isHidden = true
            genreLabel.textColor = .purpleBrown60Color()
        }
    }
    @IBOutlet weak var placeholderImg: UIImageView!{
        didSet {
            placeholderImg.isHidden = false
        }
    }
    @IBOutlet weak var videoSpinner: UIActivityIndicatorView!
    @IBOutlet weak var contentSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tagLineLabel: UILabel! {
        didSet {
            tagLineLabel.font = .dateFont()
            tagLineLabel.isHidden = true
            tagLineLabel.textColor = .purpleBrown60Color()
        }
    }
    @IBOutlet weak var releaseDateLabel: UILabel!  {
        didSet {
            releaseDateLabel.font = .dateFont()
            releaseDateLabel.isHidden = true
            releaseDateLabel.textColor = .purpleBrown60Color()
        }
    }
    
    @IBOutlet weak var castLabel: UILabel!  {
        didSet {
            castLabel.font = .dateFont()
            castLabel.isHidden = true
            castLabel.textColor = .purpleBrown60Color()
        }
    }
    @IBOutlet weak var overviewTextView: UITextView!{
        didSet {
            overviewTextView.font = .titleFont()
            overviewTextView.isHidden = true
        }
    }
    
    var detailType: ProgramOption?
    var viewModel: DetailViewModel?
    var program:Program?
    var youtubePlay:YTPlayerView?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxbind()
        videoSpinner.startAnimating()
        contentSpinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .semaphoreRed()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        self.title = program?.title
    }
    
    func rxbind() {
        
        guard let production = program,
            let id = production.id else { return }
        switch self.viewModel?.optionType {
        case .movies?:
            self.viewModel?.getMovieDetail(with: String(id))
                .retry(3)
                .subscribe({ [weak self] event in
                    switch event {
                    case let .next(response):
                        self?.viewModel?.rx_detail.value = response
                        self?.prepareView(response)

                    case .error:
                        print(Error.self)
                    case .completed:
                        SwiftSpinner.hide()
                    }
                }).disposed(by: disposeBag)
        default:
            self.viewModel?.getTvShowDetail(with: String(id))
                .retry(3)
                .subscribe({ [weak self] event in
                    switch event {
                    case let .next(response):
                        self?.viewModel?.rx_detail.value = response
                        self?.prepareView(response)
                    case .error:
                        print(Error.self)
                    case .completed:
                        SwiftSpinner.hide()
                    }
                }).disposed(by: disposeBag)
        }
        self.viewModel?.getMovieTvTrailer(with: String(id))
            .retry(1)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    self?.viewModel?.rx_video.value = response
                    self?.prepareVideo()
                case .error:
                    print(Error.self)
                case .completed:
                    SwiftSpinner.hide()
                }
            }).disposed(by: disposeBag)
    }
    
    func prepareView(_ program: Program) {
       
        switch program {
        case is Movie:
            guard let movie = program as? Movie,
                let releaseDate = movie.releaseDate else {
                    return
            }
            setGenres(genres: movie.genre)
            releaseDateLabel.text = "Release date: " + releaseDate
            tagLineLabel.text = movie.tagline
            overviewTextView.text = movie.overview
        default:
            guard let show = program as? TVShow,
                let releaseDate = show.airDate else {
                    return
            }
            setGenres(genres: show.genre)
            releaseDateLabel.text = "First air date: " + releaseDate
            tagLineLabel.isHidden = true
            overviewTextView.text = show.overview
        }
        titleLabel.text = program.title
        titleLabel.isHidden = false
        releaseDateLabel.isHidden = false
        overviewTextView.isHidden = false
        genreLabel.isHidden = false
        contentSpinner.stopAnimating()
        contentSpinner.isHidden = true
        guard let img = program.posterPath else {return}
        setImage(path: img)
    }
    
    private func setGenres(genres: [Genre]?) {
        guard let genreList = genres else  { return }
        var concatGenres = "Genres: "
        for genre in genreList {
            concatGenres += genre.name! + " "
        }
        genreLabel.text = concatGenres
    }
    private func setImage(path: String) {
        
        posterImg.kf.indicatorType = .activity
        let url = URL(string: imagePath+path)
        let placeholderImage = UIImage(named: "filmplaceholder")
        self.posterImg.kf.setImage(with:url,
                                   placeholder: placeholderImage,
                                   options: [.transition(.fade(0.5))],
                                   progressBlock: nil,
                                   completionHandler: nil)
    }
    
    private func prepareVideo() {
        guard let video = self.viewModel?.rx_video.value?.list?.first,
            let videoURL = video.videoPath else {
                videoSpinner.isHidden = true
                return
        }
        placeholderImg.isHidden = true
        youtubePlay = YTPlayerView(frame: self.trailerView.frame)
        youtubePlay?.load(withVideoId: videoURL)
        self.trailerView.addSubview(youtubePlay!)
        videoSpinner.stopAnimating()
        videoSpinner.isHidden = true
    }
}
