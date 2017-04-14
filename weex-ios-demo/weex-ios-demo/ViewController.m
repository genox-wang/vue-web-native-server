//
//  ViewController.m
//  weex-ios-demo
//
//  Created by bill on 2017/4/13.
//  Copyright © 2017年 loostudy. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end


@implementation ViewController

- (NSURL *)url {//定义js url
    if (!_url) {
        //读取本地JS
//        _url =  [[NSBundle mainBundle] URLForResource:@"foo"   withExtension:@"js"];
        //读取网络JS
        _url =  [NSURL URLWithString:@"http://www.happygod.cn/foo.js"];
    }
    return _url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建WXSDKInstance对象
    _instance = [[WXSDKInstance alloc] init];
    // 设置weexInstance所在的控制器
    _instance.viewController = self;
    // 根据weex对instance的设计规范，需要渲染中知道最外层body的位置和尺寸。这个frame值的设置，跟最终在回调中获取的view.frame一致。
    // 当然，在很多场景下，仅需要在一个native页面的局部渲染weex区块。很简单，您只需要将instance.frame设置为目标区块的位置尺寸即可。
    _instance.frame = self.view.frame; //必需

    // 设置weexInstance用于渲染的`js`的URL路径
    [_instance renderWithURL:self.url options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
    // 为了避免循环引用声明一个弱指针的`self`
    __weak typeof(self) weakSelf = self;
    // 设置weexInstance创建完毕回调
    _instance.onCreate = ^(UIView *view) {
        weakSelf.weexView = view;
        [weakSelf.weexView removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    // 设置`weexInstance`出错的回调
    _instance.onFailed = ^(NSError *error) {
        //process failure
        NSLog(@"处理失败:%@",error);
    };
    //设置渲染完成的回调
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        NSLog(@"渲染完成");
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //  销毁WXSDKInstance实例
    [self.instance destroyInstance];
}


@end
