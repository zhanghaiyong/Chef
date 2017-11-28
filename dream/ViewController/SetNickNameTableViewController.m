//
//  SetMsgTableViewController.m
//  dream
//
//  Created by zhy on 17/2/7.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "SetNickNameTableViewController.h"

@interface SetNickNameTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTF;

@end

@implementation SetNickNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, -80);
    if ([self.flag isEqualToString:@"nickSegue"]) {
        self.title = @"设置昵称";
        self.contentTF.text = [AVUser currentUser].username;
    }else {
    
        self.title = @"个性签名";
        self.contentTF.text = [AVUser currentUser][@"sign"];
    }
}

- (IBAction)submitAction:(id)sender {
    
    if (self.contentTF.text.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"内容不能为空" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    if ([self.flag isEqualToString:@"nickSegue"]) {
        [AVUser currentUser].username = self.contentTF.text;
    }else {
        
        [[AVUser currentUser] setObject:self.contentTF.text forKey:@"sign"];
    }
    
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            [[HUDConfig shareHUD]SuccessHUD:nil delay:DELAY];
            
            [AVUser currentUser].fetchWhenSave = true;
            if (_refreshNickNameBlock) {
                _refreshNickNameBlock(self.contentTF.text);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
        
            [[HUDConfig shareHUD]ErrorHUD:nil delay:DELAY];
        }
        
    }];
}

@end
