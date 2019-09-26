//
//  YYBaseAnimation.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

class YYBaseAnimation: NSObject {

    private(set) var isPresenting: Bool = false
    public init(_ isPresenting: Bool) {
        super.init()
        self.isPresenting = isPresenting
    }
    
    init(_ isPresenting: Bool, preferredStyle: YYAlertControllerStyle) {
        
    }
}
extension YYBaseAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimateTransition(transitionContext)
        }else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    /// override present
    @objc func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) -> Void {
    }
    /// override dismiss
    @objc func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) -> Void {
    }
}
