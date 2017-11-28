//
//  LoadingViewController.m
//  Waistcoat
//
//  Created by 张海勇 on 2017/9/16.
//  Copyright © 2017年 zhy. All rights reserved.
//

#import "LoadingViewController.h"
#import "SegmentTitView.h"
#import "BaseTabBarController.h"
@interface LoadingViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)SegmentTitView *segmentView;
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//            AVObject *obj = [AVObject objectWithClassName:@"oneClass"];
//            [obj setObject:@"YES" forKey:@"show"];
//            [obj setObject:@"http:www.baidu.com" forKey:@"url"];
//
//            if ([obj save]) {
//                NSLog(@"存储成功");
//            }else {
//
//                NSLog(@"失败的话");
//            }
    
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.view.backgroundColor = [UIColor whiteColor];

    AVQuery *query = [AVQuery queryWithClassName:@"oneClass"];
    __weak LoadingViewController *weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            AVObject *obj = objects[0];
            if ([obj[@"show"] isEqualToString:@"YES"]) {
                
                weakSelf.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-kHomeBarHeight-50)];
                weakSelf.webView.backgroundColor = [UIColor whiteColor];
                weakSelf.webView.delegate = self;
                weakSelf.webView.scrollView.bounces = NO;
                weakSelf.webView.scrollView.showsVerticalScrollIndicator = NO;
                weakSelf.webView.scrollView.showsHorizontalScrollIndicator = NO;
                NSURL *debugURL=[NSURL URLWithString:obj[@"url"]];
                NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
                [weakSelf.webView loadRequest:request];
                [weakSelf.view addSubview:weakSelf.webView];
                
            }else {
                
                UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
                BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
                [UIApplication sharedApplication].delegate.window.rootViewController = tabBar;
            }
        }else {
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
            BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
            [UIApplication sharedApplication].delegate.window.rootViewController = tabBar;
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (!_segmentView) {
        __weak LoadingViewController *weakSelf = self;
        _segmentView = [[SegmentTitView alloc]initWithFrame:CGRectMake(0, KDeviceHeight-40-kHomeBarHeight, kDeviceWidth, 50) titles:@[@"首页",@"后退",@"前进"]];
        _segmentView.tapLabBack = ^(NSInteger index) {
            switch (index) {
                case 0:
                    [weakSelf.webView reload];
                    break;
                case 1:
                    [weakSelf.webView goBack];
                    break;
                case 2:
                    [weakSelf.webView goForward];
                    break;
                default:
                    break;
            }
        };
        [weakSelf.view addSubview:_segmentView];
    }

    [SVProgressHUD dismiss];
    return YES;
}



@end
