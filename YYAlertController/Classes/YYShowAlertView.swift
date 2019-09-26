//
//  YYShowAlertView.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

public class YYShowAlertView: UIView {
    fileprivate(set) var alertView: UIView?
    public var backgroundView: UIView? {
        willSet {
            if self.backgroundView != nil && self.backgroundView != newValue {
                self.backgroundView?.removeFromSuperview()
            }
        }
        didSet {
            addBackgroundView()
            addSingleGesture()
        }
    }
    public var backgoundTapDismissEnable: Bool = false {
        didSet {
            singleTap?.isEnabled = self.backgoundTapDismissEnable
        }
    }
    public var alertViewOriginY: CGFloat = 0
    public var alertViewEdging: CGFloat = 15
    ///私有变量
    fileprivate weak var singleTap: UITapGestureRecognizer?
    fileprivate var currentWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
    //MARK: init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addBackgroundView()
        addSingleGesture()
        backgoundTapDismissEnable = false
    }
    public init(alertView tipView: UIView) {
        super.init(frame: .zero)
        addBackgroundView()
        addSingleGesture()
        backgoundTapDismissEnable = false
        alertView = tipView
        addSubview(tipView)
    }
    
    ///类方法初始化
    public class func alertViewWithView(_ alertView: UIView) -> YYShowAlertView {
        return YYShowAlertView.init(alertView: alertView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        if self.superview != nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.superview?.addConstraintToView(self, edgeInset: .zero)
            layoutAlertView()
        }
    }
    ///Dealloc
    deinit {
        print("Dealloc:\(NSStringFromClass(self.classForCoder))")
    }

//MARK: hide  和 show
    /// hide
    public func hide() -> Void {
        if superview != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.alertView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.alpha = 0
                
            }) { (finished) in
                self.removeFromSuperview()
            }
        }
    }
    /// show
    public func show() -> Void {
        if superview == nil {
            currentWindow?.addSubview(self)
        }
        alpha = 0
        alertView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25) {
            self.alertView?.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }
}
//MARK: 相关配置
fileprivate extension YYShowAlertView {
    func addBackgroundView() {
        if backgroundView == nil {
            let backgroundView = UIView.init(frame: bounds)
            backgroundView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.backgroundView = backgroundView
        }
        insertSubview(backgroundView!, at: 0)
        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        addConstraintToView(backgroundView!, edgeInset: .zero)
    }
    func addSingleGesture() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        singleTap = tap
        singleTap?.isEnabled = backgoundTapDismissEnable
        backgroundView?.addGestureRecognizer(tap)
    }
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        hide()
    }
    
    func layoutAlertView() {
        if alertView == nil {
            return
        }
        //center x
        alertView?.translatesAutoresizingMaskIntoConstraints = false
        addContraintCenterXToView(alertView, centerYToView: nil)
        
        //width height
        if !(alertView?.frame.size.equalTo(.zero))! {
            alertView?.addConstraintWidth(alertView!.frame.width, height: alertView!.frame.height)
        }else {
            var findAlertViewWidthConstraint = false
            for constraint in alertView!.constraints {
                if constraint.firstAttribute == .width {
                    findAlertViewWidthConstraint = true
                    break
                }
            }
            if findAlertViewWidthConstraint == false {
                alertView?.addConstraintWidth(superview!.frame.width - 2 * alertViewEdging, height: 0)
            }
        }
        
        // topY
        let alertViewCenterYConstraint = self.addContraintCenterYToView(alertView, constant: 0)
        if alertViewOriginY > 0 {
            alertView?.layoutIfNeeded()
            alertViewCenterYConstraint?.constant = alertViewOriginY - (superview!.frame.height - alertView!.frame.height) / 2
        }
        
    }
}
//MARK: 方法showAlert
extension YYShowAlertView {
    public class func showAlertViewWithView(_ alertView: UIView) {
        showAlertViewWithView(alertView, backgoundTapDismissEnable: false)
    }
    
    public class func showAlertViewWithView(_ alertView: UIView, backgoundTapDismissEnable enable: Bool) {
        let showTipView = self.alertViewWithView(alertView)
        showTipView.backgoundTapDismissEnable = enable
        showTipView.show()
    }
    
    public class func showAlertViewWithView(_ alertView: UIView, originY: CGFloat) {
        showAlertViewWithView(alertView, originY: originY, backgoundTapDismissEnable: false)
    }
    
    public class func showAlertViewWithView(_ alertView: UIView, originY: CGFloat, backgoundTapDismissEnable enable: Bool) {
        let showTipView = self.alertViewWithView(alertView)
        showTipView.backgoundTapDismissEnable = enable
        showTipView.alertViewOriginY = originY
        showTipView.show()
    }
}
