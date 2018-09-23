//
//  ProgramListCell.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/22/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit

class ProgramListCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    func buildCell(for program: Program) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        titleLabel.text = program.title
        averageVoteLabel.text = String(describing: program.averageVote)
        switch program {
        case is Movie:
            guard let movie = program as? Movie,
                let releaseDate = movie.releaseDate else {
                    return
            }
            releaseDateLabel.text = formatter.string(from: releaseDate)
        default:
            guard let tvShow = program as? TVShow,
                let releaseDate = tvShow.airDate else {
                    return
            }
            releaseDateLabel.text = formatter.string(from: releaseDate)
        }
    }
}
