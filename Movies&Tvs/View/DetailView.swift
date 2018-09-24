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

class DetailView: UIViewController {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    private var detailType: ProgramOption?
    private var program:Program?
    
    init(_ program: Program, detailType: ProgramOption) {
        super.init(nibName: nil, bundle: nil)
        self.detailType = detailType
        self.program = program
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
