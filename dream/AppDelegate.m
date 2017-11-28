//
//  AppDelegate.m
//  dream
//
//  Created by zhy on 17/1/13.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "IFTTTJazzHandsViewController.h"
#import "AppDelegate+UPush.h"
#import "LoadingViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    [self setUMessageApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [AVOSCloud setApplicationId:@"H3lVSIEx4A2G2BKE0TJFjRUl-gzGzoHsz" clientKey:@"YAszhD4PHrgUb5EQHCNWge8R"];
    
    //跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[UITabBar appearance] setTintColor:[UIColor brownColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor brownColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFang-SC-Medium" size: 18], NSFontAttributeName, nil]];
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    if (![Uitils getUserDefaultsForKey:@"firstBegin"]) {
        
        [Uitils setUserDefaultsObject:@"YES" ForKey:@"firstBegin"];
        
        IFTTTJazzHandsViewController *tabBar = [IFTTTJazzHandsViewController new];
        self.window.rootViewController = tabBar;
        
    }else {
    
        LoadingViewController *loadVC = [LoadingViewController new];
        self.window.rootViewController = loadVC;
        

    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
