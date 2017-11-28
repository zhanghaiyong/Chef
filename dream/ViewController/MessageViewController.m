//
//  MessageViewController.m
//  dream
//
//  Created by zhy on 17/1/23.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "MessageViewController.h"
#import "SetNickNameTableViewController.h"
#import "SexViewController.h"
@interface MessageViewController ()
{
    AVUser *user;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *sign;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"个人信息";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    user = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_File"];
    [query whereKey:@"objectId" equalTo:user[@"avatar"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects.count > 0) {
            
            AVObject *obj = objects[0];
            AVFile *file = [AVFile fileWithURL:obj[@"url"]];
            
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                self.avatar.image = [UIImage imageWithData:data];
                
            } progressBlock:^(NSInteger percentDone) {
                //下载的进度数据，percentDone 介于 0 和 100。
            }];
        }else {
            
            self.avatar.image = [UIImage imageNamed:@"big默认"];
        }
    }];
    
    self.nickName.text = user[@"username"];
    
    if (user[@"mobilePhoneNumber"]) {
        
        self.phone.text = user[@"mobilePhoneNumber"];
    }else {
    
        self.phone.text = @"去绑定手机号";
    }
    
    if (user[@"birthday"]) {
        
         self.birthday.text = user[@"birthday"];
    }else {
        
        self.birthday.text = @"去设置";
    }
    
    self.sex.text = user[@"sex"];
    
    if (!user[@"sign"]) {
        
        self.sign.text = @"你什么都没有留下";
    }else {
    
        self.sign.text = user[@"sign"];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


    
    if ([segue.identifier isEqualToString:@"nickSegue"]) {
        
        SetNickNameTableViewController *Nickname = (SetNickNameTableViewController *)segue.destinationViewController;
        Nickname.flag = segue.identifier;
        Nickname.refreshNickNameBlock = ^(NSString *text) {
        
            self.nickName.text = text;
        };
    }else if ([segue.identifier isEqualToString:@"signSegue"]) {
    
        SetNickNameTableViewController *sign = (SetNickNameTableViewController *)segue.destinationViewController;
        sign.flag = segue.identifier;
        sign.refreshNickNameBlock = ^(NSString *text) {
            
            self.sign.text = text;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if ([segue.identifier isEqualToString:@"sexSegue"]) {
    
        SexViewController *sex = (SexViewController *)segue.destinationViewController;
        sex.refreshNickNameBlock = ^(NSString *text) {
            
            self.sex.text = text;
        };
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0: {
            
                TakePhotoViewController *TakePhoto = [[TakePhotoViewController alloc]init];
                [TakePhoto returnImage:^(UIImage *image) {
                    
                    [[HUDConfig shareHUD]alwaysShow];
                    
                    self.avatar.image = image;
                    NSData *data = UIImagePNGRepresentation(image);
                    AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@avatar",[AVUser currentUser].mobilePhoneNumber] data:data];
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if (succeeded) {
                            
                            [user setObject:file.objectId forKey:@"avatar"];
                            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    
                                    [[AVUser currentUser] setFetchWhenSave:YES];
                                    [[HUDConfig shareHUD]SuccessHUD:@"修改成功" delay:DELAY];
                                } else {
                                    [[HUDConfig shareHUD]SuccessHUD:@"修改失败" delay:DELAY];
                                }
                            }];
                        }else {
                        
                            [[HUDConfig shareHUD]SuccessHUD:@"修改失败" delay:DELAY];
                        }
                    }];
                    
                }];
                [self presentViewController:TakePhoto animated:YES completion:nil];
            
            }
                
                break;
                
            default:
                break;
        }
    }
}

@end
