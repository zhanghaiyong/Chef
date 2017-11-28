//
//  RegisterViewController.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseTabBarController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *repwdTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (strong, nonatomic) UIImage *avatarImg;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chosePhoto)];
    [self.avatar addGestureRecognizer:tap];
    
}

- (void)chosePhoto {

    TakePhotoViewController *TakePhoto = [[TakePhotoViewController alloc]init];
    [TakePhoto returnImage:^(UIImage *image) {
        
        self.avatar.image = image;
        self.avatarImg = image;
        
    }];
    [self presentViewController:TakePhoto animated:YES completion:nil];
}


- (IBAction)showPwdAction:(id)sender {

    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        self.pwdTF.secureTextEntry = YES;
        self.repwdTF.secureTextEntry = YES;
        button.selected = NO;
        
    }else {
        
        self.pwdTF.secureTextEntry = NO;
        self.repwdTF.secureTextEntry = NO;
        button.selected = YES;
    }
}

- (IBAction)choseSexAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    self.manBtn.selected = NO;
    self.womanBtn.selected = NO;
    button.selected = YES;
    
}

- (IBAction)submitAction:(id)sender {

    [[HUDConfig shareHUD] alwaysShow];
    
    if (self.nickName.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"起一个响亮的昵称吧" delay:DELAY];
        return;
    }
    
    if (self.pwdTF.text.length == 0 || self.repwdTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"输入密码" delay:DELAY];
        return;
    }
    
    if (![self.pwdTF.text isEqualToString:self.repwdTF.text]) {
        
        [[HUDConfig shareHUD]Tips:@"两次密码不一致" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    
    AVUser *user = [AVUser currentUser];
    user.username = self.nickName.text;// 设置用户名
    [user setObject:self.manBtn.selected?@"男":@"女" forKey:@"sex"];
    // 设置密码
    [user updatePassword:@"123" newPassword:self.pwdTF.text block:^(id  _Nullable object, NSError * _Nullable error) {
        
        if (!error) {
            
            if (self.avatarImg != nil) {
                
                NSData *data = UIImagePNGRepresentation(self.avatarImg);
                AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@avatar",[AVUser currentUser].mobilePhoneNumber] data:data];
                [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    //头像id
                    [user setObject:file.objectId forKey:@"avatar"];
                    
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            // 注册成功
                            [[HUDConfig shareHUD]SuccessHUD:@"注册成功" delay:DELAY];
                            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
                            BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
                            UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
                            window.rootViewController = tabBar;
                        } else {
                            // 失败的原因可能有多种，常见的是用户名已经存在。
                            [[HUDConfig shareHUD]SuccessHUD:error.localizedDescription delay:DELAY];
                        }
                    }];
                }];
            }else {
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        // 注册成功
                        [[HUDConfig shareHUD]SuccessHUD:@"注册成功" delay:DELAY];
                        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
                        BaseTabBarController *tabBar = [SB instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
                        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
                        window.rootViewController = tabBar;
                    } else {
                        // 失败的原因可能有多种，常见的是用户名已经存在。
                        [[HUDConfig shareHUD]SuccessHUD:error.localizedDescription delay:DELAY];
                    }
                }];
            }
            
        }else {
        
            [[HUDConfig shareHUD]SuccessHUD:@"网络错误，请重试" delay:DELAY];
        }
        
    }];
}


#pragma mark UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
}

@end
