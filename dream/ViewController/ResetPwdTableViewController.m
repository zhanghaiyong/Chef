//
//  ResetPwdTableViewController.m
//  dream
//
//  Created by zhy on 17/2/7.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "ResetPwdTableViewController.h"

@interface ResetPwdTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldTextF;

@property (weak, nonatomic) IBOutlet UITextField *firstTF;

@property (weak, nonatomic) IBOutlet UITextField *secondTF;

@end

@implementation ResetPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";

}
- (IBAction)submitAction:(id)sender {
    
    if (self.oldTextF.text.length == 0 ) {
        
        [[HUDConfig shareHUD]Tips:@"请输入旧密码" delay:DELAY];
        return;
    }
    
    if (self.firstTF.text.length == 0 || self.secondTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请输入新密码" delay:DELAY];
        return;
    }
    
    if ([self.oldTextF.text isEqualToString:self.firstTF.text]) {
        
        [[HUDConfig shareHUD]Tips:@"新密码不能和旧密码一致" delay:DELAY];
        return;
    }
    
    if (![self.firstTF.text isEqualToString:self.secondTF.text]) {
        
        [[HUDConfig shareHUD]Tips:@"新密码输入不一致" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    
    [[AVUser currentUser] updatePassword:self.oldTextF.text newPassword:self.firstTF.text block:^(id  _Nullable object, NSError * _Nullable error) {
    
        if (!error) {
            
          [[HUDConfig shareHUD]SuccessHUD:@"修改成功" delay:DELAY];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
        
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        }
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

@end
