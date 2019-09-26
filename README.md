# YYAlertController

[![CI Status](https://img.shields.io/travis/YaoChengZhen/YYAlertController.svg?style=flat)](https://travis-ci.org/YaoChengZhen/YYAlertController)
[![Version](https://img.shields.io/cocoapods/v/YYAlertController.svg?style=flat)](https://cocoapods.org/pods/YYAlertController)
[![License](https://img.shields.io/cocoapods/l/YYAlertController.svg?style=flat)](https://cocoapods.org/pods/YYAlertController)
[![Platform](https://img.shields.io/cocoapods/p/YYAlertController.svg?style=flat)](https://cocoapods.org/pods/YYAlertController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
如果想要完整Demo可以下载：https://github.com/YaoChengZhen/AlertViewDemo.git

## Requirements

## Installation

YYAlertController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod 'YYAlertController'
end
```
Then, run the following command:

```ruby
$ pod install
```
## Use
1.Default alert
```swift
        let alertView = YYAlertView.init(title: "提示", message: "确定要删除吗？")
        //alertView.layer.cornerRadius = 8
        //alertView.layer.masksToBounds = true
//        alertView.buttonDefaultBgColor = UIColor.red
        alertView.addAction(YYAlertAction.init("取消", style: .cancle, handler: { (action) in
            print("取消啦")
        }))
        //循环引用
        alertView.addAction(YYAlertAction.init("确定", style: .defalut, handler: { (action) in
            print("确定")
        }))
        alertView.show(in: self, preferredStyle: .alert)
        //alertView.show(in: self)
        
        //        let alertVC = YYAlertController.init(alertView, preferredStyle: .alert)
//        YYAlertController.initWithAlertView(alertView) //另一种初始方法
//        self.present(alertVC, animated: true, completion: nil)
```
2.ActionSheet
```swift
        let alertView = YYAlertView.init(title: "提示", message: "info")
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
    //        alertView.buttonDefaultBgColor = UIColor.red
        alertView.addAction(YYAlertAction.init("取消", style: .cancle, handler: { (action) in
                print("取消啦")
        }))
        alertView.addAction(YYAlertAction.init("summit", style: .defalut, handler: { (action) in
                print("取消啦")
        }))
        alertView.addAction(YYAlertAction.init("确定", style: .defalut, handler: { (action) in
                print("确定")
        }))
        alertView.show(in: self, preferredStyle: .actionSheet)
```
3. ShowInWindow
```swift
//文本自适应
        let alertView = YYAlertView.alertViewWithTitle("YYAlertView", message: "A message should be a short, but it can support long message, this is ver heard HHhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh. (NSTextAlignmentCenter)")
        alertView.addAction(YYAlertAction.init("取消", style: .cancle, handler: { (action) in
            
        }))
        alertView.addAction(YYAlertAction.init("确定", style: .defalut, handler: { (action) in
            
        }))
        alertView.showInWindow()
```
4. TextField Alert
```swift
      let alertView = YYAlertView.init(title: "提示", message: "输入相关信息")
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        //        alertView.buttonDefaultBgColor = UIColor.red
        alertView.addTextFieldWithConfigurationHandler { (textField) in
            print(textField.text)
            textField.placeholder = "请输入手机号"
        }
        alertView.addTextFieldWithConfigurationHandler { (textField) in
            print(textField.text)
            textField.placeholder = "请输入密码"
        }
        alertView.addAction(YYAlertAction.init("取消", style: .cancle, handler: { (action) in
                print("取消啦")
        }))
        alertView.addAction(YYAlertAction.init("确定", style: .defalut, handler: { (action) in
                print("确定")
        }))
        alertView.show(in: self, preferredStyle: .alert)
```
5. CustomView
```swift
//支持自定义视图，包括利用xib创建的视图
        let customView = YCustomView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.7, height: 300))
        titleView.backgroundColor = UIColor.white
        let alertVC = YYAlertController.init(titleView, preferredStyle: .alert)
        alertVC.bcgTapDismissEnable = true
        self.present(alertVC, animated: true, completion: nil)
```
## Author

YaoChengZhen, 2550884372@qq.com

## License

YYAlertController is available under the MIT license. See the LICENSE file for more info.
