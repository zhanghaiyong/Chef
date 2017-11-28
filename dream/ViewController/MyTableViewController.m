//
//  MyTableViewController.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "MyTableViewController.h"
#import "PwdLoginViewController.h"

@interface MyTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiteBtn;

@end

@implementation MyTableViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    if (![AVUser currentUser]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未登录状态不能发布菜品，是否登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"暂不登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedIndex = 0;
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            PwdLoginViewController *login = [SB instantiateViewControllerWithIdentifier:@"PwdLoginViewController"];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
            [self presentViewController:navi animated:YES completion:^{
                self.tabBarController.selectedIndex = 0;
            }];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
    
        [self initData];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(-80, 0, -80, 0);
    self.tableView.tableFooterView = [UIView new];
}


- (void)initData {

    AVUser *user = [AVUser currentUser];
    
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
    
    NSString *expri = user[@"experience"];
    self.levelLabel.text = [NSString stringWithFormat:@"%ld",[expri integerValue]/EXPRI];
    
    NSArray *collects = user[@"collect"];
    NSArray *likes = user[@"likes"];
    NSArray *dislikes = user[@"dislikes"];
    [self.collect setTitle:[NSString stringWithFormat:@"%ld",collects.count] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",likes.count] forState:UIControlStateNormal];
    [self.hiteBtn setTitle:[NSString stringWithFormat:@"%ld",dislikes.count] forState:UIControlStateNormal];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1 || section == 2) {
        
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0;
}

@end
