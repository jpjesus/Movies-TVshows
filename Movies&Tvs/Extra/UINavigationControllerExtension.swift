//
//  UINavigationControllerExtension.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushFadeAnimation(viewController: UIViewController) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
        view.layer.removeAllAnimations()
    }
    
    func popFadeAnimation() {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
        view.layer.removeAllAnimations()
    }
}
