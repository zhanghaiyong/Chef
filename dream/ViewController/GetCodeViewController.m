//
//  GetCodeViewController.m
//  dream
//
//  Created by zhy on 17/2/8.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "GetCodeViewController.h"
#import "VerifyViewController.h"
@interface GetCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证手机号码";
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)getCodeAction:(id)sender {
    
    if (self.phoneTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请输入你的手机号" delay:DELAY];
        return;
    }
    
    if (self.phoneTF.text.isMobilphone) {
        
        [[HUDConfig shareHUD]Tips:@"请输入正确的手机号" delay:DELAY];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码到这个号码:%@",self.phoneTF.text] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[HUDConfig shareHUD]alwaysShow];
        
        AVUser *user = [AVUser user];
        user.username = @"visitor";
        user.password =  @"123";
        user.mobilePhoneNumber = self.phoneTF.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (succeeded) {
                
                 [[HUDConfig shareHUD] SuccessHUD:@"发送成功" delay:DELAY];
                 UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                 VerifyViewController *verify = [SB instantiateViewControllerWithIdentifier:@"VerifyViewController"];
                 verify.phone = self.phoneTF.text;
                 [self.navigationController pushViewController:verify animated:YES];
            }else {
            
                NSLog(@"错误信息：%@  %ld",error,error.code);
                [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
            }
            
        }];
        
        
//        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
//        [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneTF.text];
//        
//        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//            
//            NSLog(@"count = %ld",objects.count);
//            
//            if (objects.count > 0) {
//                
//                [[HUDConfig shareHUD]ErrorHUD:@"此手机号已注册" delay:DELAY];
//            }else {
//                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTF.text zone:@"86"
// customIdentifier:nil result:^(NSError *error){
//                     if (!error) {
//                         NSLog(@"获取验证码成功");
//                         [[HUDConfig shareHUD] SuccessHUD:@"发送成功" delay:DELAY];
//                         UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                         VerifyViewController *verify = [SB instantiateViewControllerWithIdentifier:@"VerifyViewController"];
//                         verify.phone = self.phoneTF.text;
//                         [self.navigationController pushViewController:verify animated:YES];
//                     } else {
//                         NSLog(@"错误信息：%@",error);
//                         [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
//                     }
//                 }];
//            }
//        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
