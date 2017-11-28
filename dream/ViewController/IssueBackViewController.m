//
//  IssueBackViewController.m
//  dream
//
//  Created by zhy on 17/2/7.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "IssueBackViewController.h"

@interface IssueBackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@end

@implementation IssueBackViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.tableView.tableFooterView = [UIView new];
}


- (IBAction)submitAction:(id)sender {
    
    if (![self.contentTV.text isEqualToString:@"请输入您的意见"] && self.contentTV.text.length>0) {
        
        [[HUDConfig shareHUD]alwaysShow];
        
        AVObject *obj = [AVObject objectWithClassName:@"issue"];
        [obj setObject:[AVUser currentUser] forKey:@"user"]; //用户
        [obj setObject:self.contentTV.text forKey:@"content"]; //内容
        
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (succeeded) {
                [[HUDConfig shareHUD]SuccessHUD:nil delay:DELAY];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else {
              [[HUDConfig shareHUD]ErrorHUD:nil delay:DELAY];
            }
            
        }];
    }else {
    
        [[HUDConfig shareHUD]Tips:@"请输入你的意见" delay:DELAY];
    }

    
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:@"请输入您的意见"]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if (textView.text.length == 0) {
        textView.text = @"请输入您的意见";
        textView.textColor = [UIColor lightGrayColor];
    }
}

@end
