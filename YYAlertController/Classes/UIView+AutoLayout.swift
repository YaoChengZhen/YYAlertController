//
//  UIView+AutoLayout.swift
//  YTAlertDemo
//
//  Created by just so so on 2019/9/23.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintToView(_ view: UIView, edgeInset: UIEdgeInsets) -> Void {
        addConstraintWithView(view, topView: self, leftView: self, bottomView: self, rightView: self, edgeInset: edgeInset)
    }
    
    func addConstraintWithView(_ view: UIView, topView: UIView?, leftView: UIView?, bottomView: UIView?, rightView: UIView?, edgeInset: UIEdgeInsets) -> Void {
        //✅
        if topView != nil {
            let topLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: topView!, attribute: .top, multiplier: 1, constant: edgeInset.top)
            addConstraint(topLayoutConstraint)
        }
        
        if leftView != nil {
            let leftLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .left, relatedBy: .equal, toItem: leftView!, attribute: .left, multiplier: 1, constant: edgeInset.left)
            addConstraint(leftLayoutConstraint)
        }
        
        if (rightView != nil) {
            let rightLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .right, relatedBy: .equal, toItem: rightView!, attribute: .right, multiplier: 1, constant: edgeInset.right)
            addConstraint(rightLayoutConstraint)
        }
        
        if (bottomView != nil) {
            let bottomLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomView!, attribute: .bottom, multiplier: 1, constant: edgeInset.bottom)
            addConstraint(bottomLayoutConstraint)
        }
    }
    
    func addConstraint(_ leftView: UIView, toRightView rightView: UIView, constant: CGFloat) {
        let topBottomConstraint = NSLayoutConstraint.init(item: leftView, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: .left, multiplier: 1, constant: -constant)
        addConstraint(topBottomConstraint)
    }
    
    func addConstraintWithLeftView(_ leftView: UIView, toRightView rightView: UIView, constant: CGFloat) -> Void {
        let topBottomConstraint = NSLayoutConstraint.init(item: leftView, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: .left, multiplier: 1, constant: -constant)
        addConstraint(topBottomConstraint)
    }
    
    func addConstraintWithTopView(_ topView: UIView, toBottomView bottomView: UIView, constant: CGFloat) -> NSLayoutConstraint {
//        ✅
        let topBottomConstraint = NSLayoutConstraint.init(item: topView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: -constant)
        addConstraint(topBottomConstraint)
        return topBottomConstraint
    }
    
    func addConstraintWidth(_ width: CGFloat, height: CGFloat) -> Void {
        if (width > 0) {
            let widthConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width)

            addConstraint(widthConstraint)
        }
        if (height > 0) {
            let heightConstraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: height)
            addConstraint(heightConstraint)
        }
    }
    
    func addConstraintEqualWithView(_ view: UIView, widthToView wView: UIView?, heightToView hView: UIView?) -> Void {
        if wView != nil {
            let constraintW = NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: wView!, attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(constraintW)
        }
        
        if hView != nil {
            let constraintH = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: hView!, attribute: .height, multiplier: 1, constant: 0)
            self.addConstraint(constraintH)
        }
        
    }
    
    func addContraintCenterXToView(_ xView: UIView?, centerYToView yView: UIView?) {
        if xView != nil {
            let centerXConstraint = NSLayoutConstraint.init(item: xView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
            self.addConstraint(centerXConstraint)
        }
        if yView != nil {
            let centerYConstraint = NSLayoutConstraint.init(item: yView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
            self.addConstraint(centerYConstraint)
        }
    }
    
    func addContraintCenterYToView(_ yView: UIView?, constant: CGFloat) -> NSLayoutConstraint? {
        //✅
        if yView != nil {
            let centerYConstraint = NSLayoutConstraint.init(item: yView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: constant)
            self.addConstraint(centerYConstraint)
            return centerYConstraint
        }
        return nil
    }
    
    func removeContraint(_ attribute: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if constraint.firstAttribute == attribute {
                removeConstraint(constraint)
                break
            }
        }
    }
    
    func removeContrain(_ view: UIView, attribute: NSLayoutConstraint.Attribute) -> Void {
        for constraint in constraints {
            if constraint.firstAttribute == attribute && view == constraint.firstItem as? UIView {
                removeConstraint(constraint)
                break
            }
        }
    }
    
    func removeAllConstraints() -> Void {
        self.removeConstraints(constraints)
    }
}
