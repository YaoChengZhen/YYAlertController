//
//  YYAlertView.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/24.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit
public class YYAlertAction: NSObject {
    class func actionWithTitle(_ title: String?, style: YYAlertView.YYAlertActionStyle, handler: ((_ action: YYAlertAction) -> Void)?) -> YYAlertAction {
        return YYAlertAction.init(title, style: style, handler: handler)
    }
    
    override init() {
        super.init()
        
    }
    init(_ title: String?, style: YYAlertView.YYAlertActionStyle, handler: ((_ action: YYAlertAction) -> Void)?) {
        super.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
//    func copy(with zone: NSZone? = nil) -> Any {
//        let theCopyObj: YYAlertAction = type(of: self).init()
//        return theCopyObj
//    }
    
    fileprivate(set) var title: String?
    fileprivate(set) var style: YYAlertView.YYAlertActionStyle?
    var enabled: Bool = true
    
    fileprivate var handler: ((_ action: YYAlertAction) -> Void)?
}
public class YYAlertView: UIView {
    fileprivate(set) weak var titleLable: UILabel?
    fileprivate(set) weak var messageLabel: UILabel?
    
    /// alertView textfield array
    var textFieldArray: Array<UITextField>? {
        return textFields
    }

    /// default 280, if 0 don't add width constraint,
    var alertViewWidth: CGFloat = 280

    /// contentView space custom default 15
    var contentViewSpace: CGFloat = 15

    // textLabel custom default 6
    var textLabelSpace: CGFloat = 6
    var textLabelContentViewEdge: CGFloat = 15
    
    // button custom
    ///defalut white
    var buttonTextColor: UIColor?
    var buttonHeight: CGFloat = 40 //defalut 40
    var buttonSpace: CGFloat = 6 //defalut 6
    
    var buttonContentViewEdge: CGFloat = 15
    var buttonContentViewTop: CGFloat = 15
    var buttonCornerRadius: CGFloat = 4
    var buttonFont: UIFont = UIFont.init(name: "HelveticaNeue", size: 16)!
    var buttonDefaultBgColor: UIColor = UIColor.init(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1)
    var buttonCancelBgColor: UIColor = UIColor.init(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1)
    var buttonDestructiveBgColor: UIColor = UIColor.init(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1)
    


   // textField custom
    var textFieldFont: UIFont = UIFont.systemFont(ofSize: 14)
    var textFieldBackgroudColor: UIColor = .white
    var textFieldBorderColor: UIColor = UIColor.init(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
   
    var textFieldHeight: CGFloat = 29
    var textFieldEdge: CGFloat = 8
    var textFieldBorderWidth: CGFloat = 0.5
    var textFieldContentViewEdge: CGFloat = 15
    
    var clickedAutoHide: Bool = true
    //MARK: 私有变量
    fileprivate var buttons: Array<UIButton> = []
    fileprivate var actions: Array<YYAlertAction> = []
    fileprivate var textFields: Array<UITextField> = []
    fileprivate var textFieldSeparateViews: Array<UIView> = []
    
    fileprivate weak var textContentView: UIView?
    fileprivate weak var textFieldContentView: UIView?
    fileprivate weak var buttonContentView: UIView?
    
//    @property (nonatomic, weak) NSLayoutConstraint *textFieldTopConstraint;
    fileprivate weak var textFieldTopConstraint: NSLayoutConstraint?
    fileprivate weak var buttonTopConstraint: NSLayoutConstraint?

    deinit {
        print("销毁：\(NSStringFromClass(self.classForCoder))")
    }
    ///初始化 YYAlertView
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureProperty()
        addContentViews()
        addTextLabels()
    }
    convenience init(title: String, message: String) {
        self.init()
        titleLable?.text = title
        messageLabel?.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func alertViewWithTitle(_ title: String, message: String) -> YYAlertView {
        return YYAlertView.init(title: title, message: message)
    }
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if (self.superview != nil) {
            layoutContentViews()
            layoutTextLabels()
        }
    }
    
    func addAction(_ action: YYAlertAction) -> Void {
        let button = UIButton.init(type: .custom)
        button.clipsToBounds = true
        button.layer.cornerRadius = buttonCornerRadius
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = buttonFont
        button.backgroundColor = buttonBgColorWithStyle(action.style!)
        button.setTitleColor(buttonTextColor, for: .normal)
    
        button.isEnabled = action.enabled
        button.tag = 10000 + buttons.count
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonClicked(_:)), for: .touchUpInside)
        
        buttonContentView?.addSubview(button)
        buttons.append(button)
        actions.append(action)
       
        if (buttons.count == 1) {
            layoutContentViews()
            layoutTextLabels()
        }
        layoutButtons()

    }
    
    func addTextFieldWithConfigurationHandler(_ configurationHandler: ((_ textField: UITextField) -> Void)?) -> Void {
        let textField = UITextField.init()
        textField.tag = 20000 + textFields.count
        textField.font = textFieldFont
        textField.translatesAutoresizingMaskIntoConstraints = false
        if configurationHandler != nil {
            configurationHandler!(textField)
        }
        textFieldContentView?.addSubview(textField)
        textFields.append(textField)

        if textFields.count > 1 {
            let separateView = UIView.init()
            separateView.backgroundColor = textFieldBorderColor;
            separateView.translatesAutoresizingMaskIntoConstraints = false
            textFieldContentView?.addSubview(separateView)
            textFieldSeparateViews.append(separateView)
        }
        if (textFields.count == 1) {
            layoutContentViews()
            layoutTextLabels()
        }
        layoutTextFields()
    }
}
//MARK:响应事件
extension YYAlertView {
    @objc fileprivate func actionButtonClicked(_ btn: UIButton) -> Void {
        let action: YYAlertAction = actions[btn.tag - 10000]

        if (clickedAutoHide) {
            hideView()
        }
        if action.handler != nil {
            action.handler!(action)
        }
    }
}
//MARK: 相关配置
extension YYAlertView {
    fileprivate func configureProperty() {
        clickedAutoHide = true
        backgroundColor = .white
    }
    //MARK: add contentview
    fileprivate func addContentViews() {
        let textContentView = UIView.init()
        addSubview(textContentView)
        self.textContentView = textContentView
        
        let textFieldContentView = UIView.init()
        addSubview(textFieldContentView)
        self.textFieldContentView = textFieldContentView
        
        let buttonContentView = UIView.init()
        buttonContentView.isUserInteractionEnabled = true
        addSubview(buttonContentView)
        self.buttonContentView = buttonContentView
        
    }
    fileprivate func addTextLabels() {
        let titleLabel = UILabel.init()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 17)
        titleLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        textContentView?.addSubview(titleLabel)
        self.titleLable = titleLabel
        
        
        let messageLabel = UILabel.init()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.init(name: "HelveticaNeue", size: 15)
        messageLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        textContentView?.addSubview(messageLabel)
        self.messageLabel = messageLabel
    }
    
    func buttonBgColorWithStyle(_ style: YYAlertActionStyle) -> UIColor {
        switch style {
        case .defalut:
            return buttonDefaultBgColor
        case .cancle:
            return buttonCancelBgColor
        case .destructive:
            return buttonDestructiveBgColor
        }
    }
}
//MARK: layout contenview
extension YYAlertView {
    fileprivate func layoutContentViews() {
        if textContentView?.translatesAutoresizingMaskIntoConstraints == false {
            // layout done
            return
        }
        if alertViewWidth > 0 {
            self.addConstraintWidth(alertViewWidth, height: 0)
        }
        
        // textContentView
        textContentView?.translatesAutoresizingMaskIntoConstraints = false
        addConstraintWithView(textContentView!, topView: self, leftView: self, bottomView: nil, rightView: self, edgeInset: UIEdgeInsets.init(top: contentViewSpace, left: textLabelContentViewEdge, bottom: 0, right: -textLabelContentViewEdge))
        
        // textFieldContentView
        textFieldContentView?.translatesAutoresizingMaskIntoConstraints = false
        textFieldTopConstraint = addConstraintWithTopView(textContentView!, toBottomView: textFieldContentView!, constant: 0)
        
        addConstraintWithView(textFieldContentView!, topView: nil, leftView: self, bottomView: nil, rightView: self, edgeInset: UIEdgeInsets.init(top: 0, left: textFieldContentViewEdge, bottom: 0, right: -textFieldContentViewEdge))
        
        // buttonContentView
        buttonContentView?.translatesAutoresizingMaskIntoConstraints = false
        buttonTopConstraint = addConstraintWithTopView(textFieldContentView!, toBottomView: buttonContentView!, constant: buttonContentViewTop)

        addConstraintWithView(buttonContentView!, topView: nil, leftView: self, bottomView: self, rightView: self, edgeInset: UIEdgeInsets.init(top: 0, left: buttonContentViewEdge, bottom: -contentViewSpace, right: -buttonContentViewEdge))
    }
    
    fileprivate func layoutTextLabels() {
        if (!titleLable!.translatesAutoresizingMaskIntoConstraints && !messageLabel!.translatesAutoresizingMaskIntoConstraints) {
            // layout done
            return;
        }
        // title
        titleLable?.translatesAutoresizingMaskIntoConstraints = false
        textContentView?.addConstraintWithView(titleLable!, topView: textContentView, leftView: textContentView, bottomView: nil, rightView: textContentView, edgeInset: .zero)
        
        // message
        messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        textContentView?.addConstraintWithTopView(titleLable!, toBottomView: messageLabel!, constant: textLabelSpace)
        textContentView?.addConstraintWithView(messageLabel!, topView: nil, leftView: textContentView, bottomView: textContentView, rightView: textContentView, edgeInset: .zero)
    }
    
    fileprivate func layoutButtons() {
        let button = buttons.last
        if buttons.count == 1 {
            buttonTopConstraint?.constant = -buttonContentViewTop
            buttonContentView?.addConstraintToView(button!, edgeInset: .zero)
            button?.addConstraintWidth(0, height: buttonHeight)
        }else if buttons.count == 2 {
            let firstButton = buttons[0]
            buttonContentView?.removeContrain(firstButton, attribute: .right)
            buttonContentView?.addConstraintWithView(button!, topView: buttonContentView, leftView: nil, bottomView: nil, rightView: buttonContentView, edgeInset: .zero)
            buttonContentView?.addConstraintWithLeftView(firstButton, toRightView: button!, constant: buttonSpace)
            buttonContentView?.addConstraintEqualWithView(button!, widthToView: firstButton, heightToView: firstButton)
        }else {
            if buttons.count == 3 {
                let firstBtn = buttons[0]
                let secondBtn = buttons[1]
                buttonContentView?.removeContrain(firstBtn, attribute: .right)
                buttonContentView?.removeContrain(firstBtn, attribute: .bottom)
                buttonContentView?.removeContrain(secondBtn, attribute: .top)
                buttonContentView?.addConstraintWithView(firstBtn, topView: nil, leftView: nil, bottomView: nil, rightView: buttonContentView, edgeInset: .zero)
                buttonContentView?.addConstraintWithTopView(firstBtn, toBottomView: secondBtn, constant: buttonSpace)

            }
            let lastSecondBtn = buttons[buttons.count - 2]
            buttonContentView?.removeContrain(lastSecondBtn, attribute: .bottom)
            buttonContentView?.addConstraintWithTopView(lastSecondBtn, toBottomView: button!, constant: buttonSpace)
            
            buttonContentView?.addConstraintWithView(button!, topView: nil, leftView: buttonContentView, bottomView: buttonContentView, rightView: buttonContentView, edgeInset: .zero)
            buttonContentView?.addConstraintEqualWithView(button!, widthToView: nil, heightToView: lastSecondBtn)
        }
    }
    
    fileprivate func layoutTextFields() {
        if textFields.count == 0  {
            return
        }
        let textField = textFields.last
        if textFields.count == 1 {
            // setup textFieldContentView
            textFieldContentView?.backgroundColor = textFieldBackgroudColor
            textFieldContentView?.layer.masksToBounds = true
            textFieldContentView?.layer.cornerRadius = 4
            textFieldContentView?.layer.borderWidth = textFieldBorderWidth
            textFieldContentView?.layer.borderColor = textFieldBorderColor.cgColor
            
            textFieldTopConstraint?.constant = -contentViewSpace
            
            textFieldContentView?.addConstraintToView(textField!, edgeInset: UIEdgeInsets.init(top: textFieldBorderWidth, left: textFieldEdge, bottom: -textFieldBorderWidth, right: -textFieldEdge))
            textField?.addConstraintWidth(0, height: textFieldHeight)
        }else {
            // textField
            let lastSecondTextField = textFields[textFields.count - 2]
            textFieldContentView?.removeContrain(lastSecondTextField, attribute: .bottom)
            textFieldContentView?.addConstraintWithTopView(lastSecondTextField, toBottomView: textField!, constant: textFieldBorderWidth)
            
            textFieldContentView?.addConstraintWithView(textField!, topView: nil, leftView: textFieldContentView, bottomView: textFieldContentView, rightView: textFieldContentView, edgeInset: UIEdgeInsets.init(top: 0, left: textFieldEdge, bottom: -textFieldBorderWidth, right: -textFieldEdge))
                        
            textField?.addConstraintWidth(0, height: textFieldHeight)

            // separateview
            let separateView = textFieldSeparateViews[textFields.count - 2]
            textFieldContentView?.addConstraintWithView(separateView, topView: nil, leftView: textFieldContentView, bottomView: nil, rightView: textFieldContentView, edgeInset: UIEdgeInsets.zero)
            textFieldContentView?.addConstraintWithTopView(separateView, toBottomView: textField!, constant: 0)
            separateView.addConstraintWidth(0, height: textFieldBorderWidth)
            
        }
    }
}
extension YYAlertView {
    public enum YYAlertActionStyle: Int {
        case defalut = 0
        case cancle = 1
        case destructive = 2
    }
}
