//
//  YYAlertDropDownAnimation.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

class YYAlertDropDownAnimation: YYBaseAnimation {

    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting == true ? 0.5 : 0.25
    }
    
    override func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertVC: YYAlertController = transitionContext.viewController(forKey: .to) as! YYAlertController
        
        alertVC.bcgView?.alpha = 0
        switch alertVC.preferredSyle {
        case .alert:
            alertVC.alertView?.alpha = 0
            alertVC.alertView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        case .actionSheet:
            print("Don't support ActionSheet style!")
        default:
            break
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertVC.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: [], animations: {
            alertVC.bcgView?.alpha = 1.0
            alertVC.alertView?.transform = CGAffineTransform.identity
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }

    }
    
    override func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let alertVC: YYAlertController = transitionContext.viewController(forKey: .from) as! YYAlertController
        UIView.animate(withDuration: 0.25, animations: {
            alertVC.bcgView?.alpha = 0
            switch alertVC.preferredSyle {
            case .alert:
                alertVC.alertView?.alpha = 0
                alertVC.alertView?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                break
            case .actionSheet:
                print("Don't support ActionSheet style!")
            case .none:
                break
            }
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
        
    }
}
