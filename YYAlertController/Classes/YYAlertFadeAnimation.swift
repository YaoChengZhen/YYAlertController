//
//  YYAlertFadeAnimation.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

class YYAlertFadeAnimation: YYBaseAnimation {

    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting == true ? 0.45 : 0.25
    }
    
    override func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertVC: YYAlertController = transitionContext.viewController(forKey: .to) as! YYAlertController
        
        alertVC.bcgView?.alpha = 0.4
        switch alertVC.preferredSyle {
        case .alert:
            alertVC.alertView?.alpha = 0
            alertVC.alertView?.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        case .actionSheet:
            alertVC.alertView?.transform = CGAffineTransform.init(translationX: 0, y: (alertVC.alertView?.frame.height)!)
        default:
            break
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertVC.view)
        UIView.animate(withDuration: 0.25, animations: {
            switch alertVC.preferredSyle {
            case .alert:
                alertVC.alertView?.alpha = 1
                alertVC.alertView?.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
                break
            case .actionSheet:
                alertVC.alertView?.transform = CGAffineTransform.init(translationX: 0, y: -10)
            case .none:
                break
            }
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                alertVC.alertView?.transform = CGAffineTransform.identity
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
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
                alertVC.alertView?.transform = CGAffineTransform.init(translationX: 0, y: (alertVC.alertView?.frame.height)!)
            case .none:
                break
            }
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
        
    }
}
