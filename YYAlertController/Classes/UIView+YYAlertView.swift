//
//  UIView+YYAlertView.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

extension UIView {
    fileprivate class func createViewFromNibName(_ nibName: String) -> UIView? {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        return nib?.first as? UIView
    }
    
    class func createViewFromNib() -> UIView?{
        return self.createViewFromNibName(NSStringFromClass(self.classForCoder()))
    }
    
    class func createViewFromNib(_ nibName: String) -> UIView?{
        return self.createViewFromNibName(nibName)
    }
    
    func viewController() -> UIViewController? {
        var next = self.superview
        while next != nil {
            let nextRes = next?.next
            if nextRes?.isKind(of: UIViewController.classForCoder()) == true {
                return nextRes as? UIViewController;
            }
            next = next?.superview
        }
        return nil
    }
}

//MARK: show in controller
extension UIView {
    func show(in vc: UIViewController) -> Void {
        
        show(in: vc, preferredStyle: .alert, transitionAnimation: .fade)
    }
    func show(in vc: UIViewController, preferredStyle: YYAlertControllerStyle) -> Void {
        show(in: vc, preferredStyle: preferredStyle, transitionAnimation: .fade)
    }
    
    
    // backgoundTapDismissEnable default NO
    func show(in vc: UIViewController, preferredStyle: YYAlertControllerStyle, backgoundTapDismissEnable enable: Bool ) -> Void {
        show(in: vc, preferredStyle: preferredStyle, transitionAnimation: .fade, backgoundTapDismissEnable: enable)
    }
    
    func show(in vc: UIViewController, preferredStyle: YYAlertControllerStyle, transitionAnimation: YYAlertControllerAnimation) -> Void {
        show(in: vc, preferredStyle: preferredStyle, transitionAnimation: transitionAnimation, backgoundTapDismissEnable: false)
    }
    
    
    func show(in vc: UIViewController, preferredStyle: YYAlertControllerStyle,  transitionAnimation: YYAlertControllerAnimation, backgoundTapDismissEnable enable: Bool) -> Void {
        
        if self.superview != nil{
            self.removeFromSuperview()
        }
        let alertController: YYAlertController = YYAlertController.initWithAlertView(self, preferedStyle: preferredStyle, animation: transitionAnimation)
        alertController.bcgTapDismissEnable = enable
//        vc.modalPresentationStyle = .fullScreen
        vc.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: show in Window
extension UIView {
    func showInWindow() -> Void {
        showInWindow(backgoundTapDismissEnable: false)
    }
    
    func showInWindow(backgoundTapDismissEnable enable: Bool) -> Void {
        if self.superview != nil{
            self.removeFromSuperview()
        }
        YYShowAlertView.showAlertViewWithView(self, backgoundTapDismissEnable: enable)

    }
    
    // backgoundTapDismissEnable default NO
    func showInWindow(originY y: CGFloat) -> Void {
        showInWindow(y, backgoundTapDismissEnable: false)
        
    }
    func showInWindow(_ originY: CGFloat, backgoundTapDismissEnable enable: Bool) -> Void {
        if self.superview != nil{
            self.removeFromSuperview()
        }
        YYShowAlertView.showAlertViewWithView(self, originY: originY, backgoundTapDismissEnable: enable)
    }
    
}

//MARK: hide
extension UIView {
    // this will judge and call right method
    func hideView() -> Void {
        if isShowInAlertController {
            hideInController()
        }else if isShowInWindow {
            hideInWindow()
        }else {
            print("self.viewController is nil, or isn't YYAlertController,or self.superview is nil, or isn't YYShowAlertView")
        }
    }
    
    func hideInWindow() -> Void {
        if isShowInWindow {
            let view: YYShowAlertView = self.superview as! YYShowAlertView
            view.hide()
        }else {
            print("self.superview is nil, or isn't YYShowAlertView")

        }
    }
    
    func hideInController() -> Void {
        if (isShowInAlertController) {
            let vc: YYAlertController = self.viewController() as! YYAlertController
            vc.dismissViewControllerAnimation(true)
        }else {
            print("self.viewController is nil, or isn't YYAlertController")

        }
        
    }
    fileprivate var isShowInAlertController: Bool {
        get {
            let vc = self.viewController()
            if vc != nil && vc!.isKind(of: YYAlertController.classForCoder()) {
                return true
            }else {
                return false
            }
        }
    }
    
    fileprivate var isShowInWindow: Bool {
        get {
            let vc = self.superview
            if vc != nil && vc!.isKind(of: YYShowAlertView.classForCoder()) {
                return true
            }else {
                return false
            }
        }
    }
    
}
