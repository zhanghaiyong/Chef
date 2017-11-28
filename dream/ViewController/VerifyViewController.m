//
//  VerifyViewController.m
//  dream
//
//  Created by zhy on 17/2/8.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "VerifyViewController.h"
#import "RegisterViewController.h"
@interface VerifyViewController ()
{
    NSTimer *timer;
    NSInteger count;
    
}
@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信验证";
    count = 60;
    self.phoneLabel.text = self.phone;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
    [self.codeTF becomeFirstResponder];
}


- (void)countdownAction {
    
    if (count > 0) {
        
        [self.alertButton setTitle:[NSString stringWithFormat:@"接收短信大约需要%ld秒",count] forState:UIControlStateNormal];
        self.alertButton.userInteractionEnabled = NO;
        count--;
    }else {
        
        [self.alertButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.alertButton.userInteractionEnabled = YES;
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)repeatGetCodeAction:(id)sender {
    
    
    [AVUser requestMobilePhoneVerify:self.phone withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[HUDConfig shareHUD]SuccessHUD:@"发送成功" delay:DELAY];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
            
        } else {
            NSLog(@"错误信息：%@",error);
            [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        }
    }];
    
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone zone:@"86"
//                       customIdentifier:nil result:^(NSError *error){
//                           if (!error) {
//                               [[HUDConfig shareHUD]SuccessHUD:@"发送成功" delay:DELAY];
//                               timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
//        
//                           } else {
//                               NSLog(@"错误信息：%@",error);
//                               [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
//                           }
//                       }];
}

- (IBAction)verifyAction:(id)sender {
 
    if (self.codeTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请输入验证码" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    
    [AVUser verifyMobilePhone:self.codeTF.text withBlock:^(BOOL succeeded, NSError *error) {
        //验证结果
        
        if (succeeded) {
            NSLog(@"验证成功");
            [[HUDConfig shareHUD]SuccessHUD:@"验证成功" delay:DELAY];
            //去设置属性
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            RegisterViewController *verify = [SB instantiateViewControllerWithIdentifier:@"RegisterViewController"];
            verify.phone = self.phone;
            [self.navigationController pushViewController:verify animated:YES];

        }else {
            NSLog(@"错误信息:%@  %ld",error,error.code);
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        }
        
    }];
    
//    [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:self.phoneLabel.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//        {
//            if (!error) {
//                NSLog(@"验证成功");
//                [[HUDConfig shareHUD]SuccessHUD:@"验证成功" delay:DELAY];
//                //去设置属性
//                UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                RegisterViewController *verify = [SB instantiateViewControllerWithIdentifier:@"RegisterViewController"];
//                verify.phone = self.phone;
//                [self.navigationController pushViewController:verify animated:YES];
//                
//            }else {
//                NSLog(@"错误信息:%@",error);
//                [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
//            }
//        }
//    }];
}

@end
