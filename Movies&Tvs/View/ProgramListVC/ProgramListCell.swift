//
//  ProgramListCell.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/22/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit
import Kingfisher

let imagePath = "https://image.tmdb.org/t/p/w500"

class ProgramListCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = .titleFont()
        }
    }
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel! {
        didSet {
            releaseDateLabel.font = .dateFont()
            releaseDateLabel.textColor = .purpleBrown60Color()
        }
    }
    
    func buildCell(for program: Program) {

        titleLabel.text = program.title
        guard let img = program.posterPath else {return}
        setImage(path: img)
        switch program {
        case is Movie:
            guard let movie = program as? Movie,
                let releaseDate = movie.releaseDate else {
                    return
            }
            releaseDateLabel.text = "Release date: " + releaseDate
        default:
            guard let tvShow = program as? TVShow,
                let releaseDate = tvShow.airDate else {
                    return
            }
            releaseDateLabel.text = releaseDate
        }
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
}
