//
//  YYAlertController.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

//MARK: AlertView类型：弹窗 下方出来的样式
public enum YYAlertControllerStyle: Int {
    case alert = 0
    case actionSheet = 1
}
//MARK: AlertView动画
public enum YYAlertControllerAnimation: Int {
    case fade = 0
    case scaleFade = 1
    case dropDown = 2
    case custom = 3
}

public class YYAlertController: UIViewController {
    ///弹窗View 只读
    private(set) var alertView: UIView?
    ///背景: 默认白色
    var bcgColor: UIColor = .white
    
    ///set coustomView to it
    var bcgView: UIView? {
        willSet {
            if self.bcgView != nil && newValue != nil{
                newValue?.translatesAutoresizingMaskIntoConstraints = false
                view.insertSubview(newValue!, aboveSubview: self.bcgView!)
                view.addConstraintToView(newValue!, edgeInset: .zero)
                newValue?.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    newValue?.alpha = 1
                }) { (finished) in
                    self.bcgView?.removeFromSuperview()
                    self.addSingleTapGesture()
                }
            }
        }
    }
    
    ///style: 只读属性
    private(set) var preferredSyle: YYAlertControllerStyle?
    
    ///Animation: 只读属性
    private(set) var transitionAnimation: YYAlertControllerAnimation?
    
    var animationClass: AnyClass?
    ///点击背景消失，弹窗 default false
    var bcgTapDismissEnable: Bool = false {
        didSet {
            singleTap?.isEnabled = self.bcgTapDismissEnable
        }
    }
    ///default center Y
    var alertViewOriginY: CGFloat = 0
    //  when width frame equal to 0,or no width constraint ,this proprty will use, default to 15 edge
    var alertStyleEdging: CGFloat = 0
    
///    default 0
    var actionSheetStyleEdging: CGFloat = 0
    
    /// alertView lifecycle block
    var viewWillShowHandler: ((_ alertView: UIView) -> Void)?
    var viewDidShowHandler: ((_ alertView: UIView) -> Void)?
    var viewWillHideHandler: ((_ alertView: UIView) -> Void)?
    var viewDidHideHandler: ((_ alertView: UIView) -> Void)?
/// dismiss controller completed block
    var dismissComplete: (() -> Void)?
    
    //MARK:私有变量
    fileprivate var alertViewCenterYConstraint: NSLayoutConstraint?
    fileprivate var alertViewCenterYOffset: CGFloat = 0

    fileprivate weak var singleTap: UITapGestureRecognizer?


    //MARK: 初始化AlertView
    init() {
        super.init(nibName: nil, bundle: nil)
        configureController()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureController()
    }
    
    init(_ alertView: UIView, preferredStyle: YYAlertControllerStyle) {
        super.init(nibName: nil, bundle: nil)
        configureController()
        self.alertView = alertView
        self.preferredSyle = preferredStyle
        self.transitionAnimation = .fade
        }
    
    fileprivate init(_ alertView: UIView, preferredStyle: YYAlertControllerStyle, animation: YYAlertControllerAnimation, animationClass: AnyClass?) {
//        super.init()
        super.init(nibName: nil, bundle: nil)
        configureController()
        self.alertView = alertView
        self.preferredSyle = preferredStyle
        self.transitionAnimation = animation
        self.animationClass = animationClass
    }
//    init(_ alertView: UIView) {
//    }
    ///创建一个Alert 默认fade动画
    class func initWithAlertView(_ view: UIView) -> YYAlertController {
        return YYAlertController.init(view, preferredStyle: .alert, animation: .fade, animationClass: nil)
    }
    ///创建一个Alert或sheet 默认fade动画
    class func initWithAlertView(_ view: UIView, preferedStyle: YYAlertControllerStyle) -> YYAlertController {
        return YYAlertController.init(view, preferredStyle: preferedStyle, animation: .fade, animationClass: nil)
    }
    
    class func initWithAlertView(_ view: UIView, preferedStyle: YYAlertControllerStyle, animation: YYAlertControllerAnimation) -> YYAlertController {
        let vc = YYAlertController.init(view, preferredStyle: preferedStyle, animation: animation, animationClass: nil)
        return vc
    }
    class func initWithAlertView(_ view: UIView, preferedStyle: YYAlertControllerStyle, animation: YYAlertControllerAnimation, animationClass: AnyClass) -> YYAlertController {
        return YYAlertController.init(view, preferredStyle: preferedStyle, animation: animation, animationClass: animationClass)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 视图相关操作
    func dismissViewControllerAnimation(_ animated: Bool) -> Void {
        dismiss(animated: true, completion: self.dismissComplete)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillHideHandler != nil && alertView != nil ? viewWillHideHandler!(alertView!) : ()
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidShowHandler != nil && alertView != nil ? viewDidShowHandler!(alertView!) : ()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidHideHandler != nil && alertView != nil ? viewDidHideHandler!(alertView!) : ()

    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addBackgroundView()
        addSingleTapGesture()
        configureAlertView()
        
        view.layoutIfNeeded()
        if YYAlertControllerStyle.alert == preferredSyle {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
//MARK: Controller相关配置
extension YYAlertController {
    fileprivate func addSingleTapGesture() {
        view.isUserInteractionEnabled = true
        bcgView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(_:)))
        tap.isEnabled = bcgTapDismissEnable
        bcgView?.addGestureRecognizer(tap)
        singleTap = tap
    }
    
    @objc fileprivate func singleTap(_ tap: UITapGestureRecognizer) {
        dismissViewControllerAnimation(true)
    }
    ///添加背景图
    fileprivate func addBackgroundView() {
        if bcgView == nil {
            let backgroundView = UIView.init()
            backgroundView.backgroundColor = bcgColor
            bcgView = backgroundView
        }
        bcgView!.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(bcgView!, at: 0)
        bcgView?.frame = self.view.frame
        view.addConstraintToView(bcgView!, edgeInset: .zero)
    }
    
    fileprivate func configureController() -> Void {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        bcgColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        bcgTapDismissEnable = false
        alertStyleEdging = 15
        actionSheetStyleEdging = 0
    }
    
    fileprivate func configureAlertView() {
        if alertView == nil {
            print("\(NSStringFromClass(self.classForCoder)): alertView is null")
            return
        }
        alertView?.isUserInteractionEnabled = true
        view.addSubview(alertView!)
        alertView?.translatesAutoresizingMaskIntoConstraints = false
        switch preferredSyle {
        case .actionSheet:
            layoutActionSheetStyleView()
            break;
        case .alert:
            layoutAlertStyleView()
            break;
        default:
            break;
        }
    }
}

//MARK: ViewLayout相关配置
extension YYAlertController {
    
    fileprivate func layoutActionSheetStyleView() {
        // remove width constaint
        if alertView == nil {
            return
        }
        for constraint in alertView!.constraints {
            if constraint.firstAttribute == .width {
                alertView?.removeConstraint(constraint)
                break
            }
        }
        // add edge constraint
        view.addConstraintWithView(alertView!, topView: nil, leftView: view, bottomView: view, rightView: view, edgeInset: UIEdgeInsets.init(top: 0, left: -actionSheetStyleEdging, bottom: 0, right: -actionSheetStyleEdging))
        
        if alertView!.frame.height > 0 {
            alertView?.addConstraintWidth(0, height: alertView!.frame.height)
        }
        
    }
    
    fileprivate func layoutAlertStyleView() {
        //center X
        view.addContraintCenterXToView(alertView, centerYToView: nil)
        configureAlertViewWidth()
        
        // top Y
        alertViewCenterYConstraint = view.addContraintCenterYToView(alertView, constant: 0)
        
        if (alertViewOriginY > 0) {
            alertView?.layoutIfNeeded()
            alertViewCenterYOffset = alertViewOriginY - (view.frame.height - alertView!.frame.height) / 2;
            alertViewCenterYConstraint?.constant = alertViewCenterYOffset
        }else{
            alertViewCenterYOffset = 0;
        }
    }
    
    fileprivate func configureAlertViewWidth() {
        
        if alertView == nil {
            return
        }
        if alertView?.frame.size.equalTo(.zero) == false {
            alertView?.addConstraintWidth((alertView?.frame.width)!, height: (alertView?.frame.height)!)
        }else {
            var findAlertViewWidthConstraint = false
            for constraint in alertView!.constraints {
                if constraint.firstAttribute == .width {
                    findAlertViewWidthConstraint = true
                    break
                }
            }
            if (!findAlertViewWidthConstraint) {
                alertView?.addConstraintWidth(view.frame.width - 2 * alertStyleEdging, height: 0)
            }
        }
        
    }
}
//MARK: Notification
extension YYAlertController {
    ///键盘弹出
    @objc fileprivate func keyboardWillShow(_ notic: Notification) -> Void {
        let keyboardRect: CGRect = notic.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let alertViewBottomEdge = (view.frame.height - alertView!.frame.height) / 2 - alertViewCenterYOffset
        
        //当开启热点时，向下偏移20px
        //修复键盘遮挡问题
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let differ = keyboardRect.height - alertViewBottomEdge

        //修复：输入框获取焦点时，会重复刷新，导致输入框文章偏移一下
        if (alertViewCenterYConstraint!.constant == -differ - statusBarHeight) {
            return;
        }
        
        if (differ >= 0) {
            alertViewCenterYConstraint!.constant = alertViewCenterYOffset - differ - statusBarHeight
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    ///键盘消失
    @objc fileprivate func keyboardWillHide(_ notic: Notification) {
        alertViewCenterYConstraint?.constant = alertViewCenterYOffset
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
//MARK: UIViewControllerTransitioningDelegate
extension YYAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.transitionAnimation {
        case .fade:
            return YYAlertFadeAnimation.init(true)
        case .scaleFade:
            return YYAlertScaleFadeAnimation.init(true)
        case .dropDown:
            return YYAlertDropDownAnimation.init(true)
            
        case .custom:
            return YYBaseAnimation.init(true)
        default:
            return nil
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.transitionAnimation {
        case .fade:
            return YYAlertFadeAnimation.init(false)
        case .scaleFade:
            return YYAlertScaleFadeAnimation.init(false)
        case .dropDown:
            return YYAlertDropDownAnimation.init(false)
            
        case .custom:
            return YYBaseAnimation.init(false)
        default:
            return nil
        }
    }
}

