//
//  Defaults.h
//  有车生活
//
//  Created by ksm on 15/11/2.
//  Copyright © 2015年 ksm. All rights reserved.
//

#ifndef Defaults_h
#define Defaults_h


#endif /* Defaults_h */

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/*
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif
*/

#ifdef DEBUG
#define FxLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define FxLog(...)
#endif

#define MainColor RGB(255,128,0)

#define KJPUSHKEY @"bf90ad21e649d8f096d3907b"

#define DELAY 2
#define EXPRI 20

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define isIPhoneX (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 812)

#define kStatusBarHeight     (isIPhoneX ? 44 : 20)
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define kHomeBarHeight       (isIPhoneX ? 34 : 0)
#define kTabBarHeight       49

#define SharedApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


#pragma mark ClassName
#define jiachangcai @"1"
#define chuangyicai @"3"
#define sucai       @"4"
#define liangcai    @"5"
#define hongpei     @"6"
#define mianshi     @"7"
#define tang        @"8"
#define tiaowei     @"9"


#define SharedApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define kNavBarHeight 64
#define kTabBarHeight 49



