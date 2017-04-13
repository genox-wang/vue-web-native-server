//
//  ViewController.h
//  weex-ios-demo
//
//  Created by bill on 2017/4/13.
//  Copyright © 2017年 loostudy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * WXSDKInstance，简单来说，就是weex渲染的实例对象。它提供给开发者诸多跟页面渲染相关的接口，
 * 包括renderWithURL、refreshInstance以及destroyInstance等，提供了几个比较重要的回调接口，
 * 方便开发者根据不同的业务场景去处理他们的逻辑，如onfailed，还提供了性能监控相关的接口。
 */
#import <WeexSDK/WXSDKInstance.h>


@interface ViewController : UIViewController

//WXSDKInstance属性
@property (nonatomic, strong) WXSDKInstance *instance;
//URL属性(用于指定加载js的URL,一般声明在接口中,我们为了测试方法写在了类扩展中.)
@property (nonatomic, strong) NSURL *url;
//Weex视图
@property (weak, nonatomic) UIView *weexView;

@end

