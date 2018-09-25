//
//  Router.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
    
}

class RouterProgram:Router {
    
    unowned var viewModel:ProgramsViewModel
    init(viewModel: ProgramsViewModel) {
        self.viewModel = viewModel
    }
    
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?) {
        
        let route = ProgamListVC.Route(rawValue: routeID)
        switch  route {
        case .programDetail?:
            if viewModel.optionType == .movies {
                let movie = parameters.flatMap {$0 as? Movie} 
                guard let production = movie,
                      let type = self.viewModel.optionType,
                      let vc = context.storyboard?.instantiateViewController(withIdentifier: "DetailViewController" ) as? DetailViewController else { return }
                vc.viewModel = DetailViewModel(type: type)
                vc.program = production
                context.navigationController?.pushFadeAnimation(viewController: vc)
            } else {
                let tvShow = parameters.flatMap{$0 as? TVShow }
                guard let production = tvShow,
                    let type = self.viewModel.optionType,
                    let vc = context.storyboard?.instantiateViewController(withIdentifier: "DetailViewController" ) as? DetailViewController else { return }
                vc.viewModel = DetailViewModel(type: type)
                vc.program = production
                context.navigationController?.pushFadeAnimation(viewController: vc)
            }
        case .none:
            return
        }
    }
}
