//
//  PwdLoginViewController.m
//  dream
//
//  Created by zhy on 17/2/8.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "PwdLoginViewController.h"
#import "BaseTabBarController.h"
@interface PwdLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation PwdLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_phoneTF setValue:@5 forKey:@"paddingLeft"];
    [_pwdTF setValue:@5 forKey:@"paddingLeft"];
}

- (IBAction)showPwdAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        self.pwdTF.secureTextEntry = YES;
        button.selected = NO;
        
    }else {
        
        self.pwdTF.secureTextEntry = NO;
        button.selected = YES;
    }
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pwdLoginAction:(id)sender {
    
    if (_phoneTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请输入手机号" delay:DELAY];
        return;
    }
    
    if (self.phoneTF.text.isMobilphone) {
        
        [[HUDConfig shareHUD]Tips:@"请输入正确的手机号" delay:DELAY];
        return;
    }
    
    if (self.pwdTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请输入密码" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD] alwaysShow];
    
    [AVUser logInWithMobilePhoneNumberInBackground:self.phoneTF.text password:self.pwdTF.text block:^(AVUser *user, NSError *error) {

        if (!error) {

            [[HUDConfig shareHUD]dismiss];
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
            BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
            UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
            window.rootViewController = tabBar;
        } else {
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        }
    }];
    
//    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
//    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneTF.text];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        
//        if (objects.count > 0) {
//        
//            AVUser *user = objects[0];
//            
//            [AVUser logInWithUsernameInBackground:user.username password:user.password block:^(AVUser *user, NSError *error) {
//                if (!error) {
//                        
//                    [[HUDConfig shareHUD]dismiss];
//                    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
//                    BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
//                    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
//                    window.rootViewController = tabBar;
//                } else {
//                    [[HUDConfig shareHUD]ErrorHUD:@"网络错误，请重试" delay:DELAY];
//                }
//            }];
//        }else {
//        
//            [[HUDConfig shareHUD]ErrorHUD:@"此手机号还未注册" delay:DELAY];
//        }
//        
//    }];
}

#pragma mark UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    /*
     if (textField == self.pwdTF) {
     
     NSString *tempString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     
     if (tempString.length > 20) {
     
     return NO;
     }
     }
     */
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField == self.pwdTF) {
     
        [self pwdLoginAction:nil];
    }
    
    return YES;
}



@end
