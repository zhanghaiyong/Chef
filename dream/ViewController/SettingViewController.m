//
//  SettingViewController.m
//  dream
//
//  Created by zhy on 17/1/23.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "SettingViewController.h"
#import "BaseTabBarController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(-80, 0, -80, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)logoutAvtion:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登陆将失去一些操作权限，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"继续退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVUser logOut];
        
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
        BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
        window.rootViewController = tabBar;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"我点错了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
