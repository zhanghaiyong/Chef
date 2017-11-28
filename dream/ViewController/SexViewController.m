//
//  SexViewController.m
//  dream
//
//  Created by zhy on 17/2/9.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

@end

@implementation SexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)submitAction:(id)sender {
    
    [[AVUser currentUser] setObject:self.manBtn.selected?@"男":@"女" forKey:@"sex"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            [[HUDConfig shareHUD]SuccessHUD:nil delay:DELAY];
            
            [AVUser currentUser].fetchWhenSave = true;
            if (_refreshNickNameBlock) {
                _refreshNickNameBlock(self.manBtn.selected?@"男":@"女");
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            [[HUDConfig shareHUD]ErrorHUD:nil delay:DELAY];
        }
        
    }];
}


- (IBAction)sexAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    self.manBtn.selected = NO;
    self.womanBtn.selected = NO;
    button.selected = YES;
}

@end
