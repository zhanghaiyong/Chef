//
//  WorksViewController.m
//  dream
//
//  Created by zhy on 17/2/6.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "CollectionViewController.h"
#import "TableCell.h"
#import "StepViewController.h"
@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    AVUser *user;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *meumArray;
@end

@implementation CollectionViewController

-(NSMutableArray *)meumArray {
    
    if (_meumArray == nil) {
        
        self.meumArray = [NSMutableArray array];
    }
    return _meumArray;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    user = [AVUser currentUser];
    
    [self addSubViews];
}

- (void)addSubViews {
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [UIView new];
    self.table.estimatedRowHeight = 100;
    self.table.rowHeight = UITableViewAutomaticDimension;
    
    
    //刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [SVProgressHUD show];
        
        
        if (user[@"collection"]) {
            AVQuery *query = [AVQuery queryWithClassName:@"meum"];
            //query.limit = 10;// 最多返回 10 条结果
            //query.skip = 0;
            [query whereKey:@"objectId" containsAllObjectsInArray:user[@"collection"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                NSLog(@"fsd = %@",objects);
                
                [self.meumArray removeAllObjects];
                [self.meumArray addObjectsFromArray:objects];
                
                [self.table reloadData];
                
                [self.table.mj_header endRefreshing];
                
                [SVProgressHUD dismiss];
                
            }];
        }else {
            [self.table.mj_header endRefreshing];
            [[HUDConfig shareHUD]Tips:@"未收藏任何作品" delay:DELAY];
        }
        

    }];
    [self.view addSubview:self.table];
    [self.table.mj_header beginRefreshing];
    
}

#pragma mark UITableViewDelegate&&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.meumArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil] lastObject];
    }
    
    AVObject *obj = self.meumArray[indexPath.section];
    
    NSArray *stars = obj[@"stars"];
    float allStar = 0;
    for (NSString *star in stars) {
        
        allStar += [star floatValue];
    }
    cell.ratingView.rate = allStar/stars.count;
    
    NSString *urlStr = obj[@"albums"];
    if([urlStr rangeOfString:@"http"].location !=NSNotFound) {
        
        AVFile *file = [AVFile fileWithURL:urlStr];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                cell.meumImg.image = [UIImage imageWithData:data];
            }
        } progressBlock:^(NSInteger percentDone) {
            //下载的进度数据，percentDone 介于 0 和 100。
        }];
    }else if ([urlStr rangeOfString:@"xoxoxo"].location != NSNotFound) {
        
        cell.meumImg.image = [UIImage imageNamed:@"上方大图"];
        
    }else {
        
        [AVFile getFileWithObjectId:urlStr withBlock:^(AVFile * _Nullable file, NSError * _Nullable error) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (!error) {
                    
                    cell.meumImg.image = [UIImage imageWithData:data];
                }
                
            } progressBlock:^(NSInteger percentDone) {
                //下载的进度数据，percentDone 介于 0 和 100。
            }];
        }];
    }
    
    
    
    cell.introLabel.text = obj[@"imtro"];
    cell.titleLabel.text = obj[@"title"];
    [cell.comment setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"comments"]).count] forState:UIControlStateNormal];
    [cell.good setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"goods"]).count] forState:UIControlStateNormal];
    [cell.bad setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"bads"]).count] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StepViewController *stepVc = [StepViewController new];
    
    //评论 点赞 踩过后，刷新界面数据
    [stepVc repeatCountBlock:^(NSInteger count, NSString *type) {
        
        TableCell *cell = (TableCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([type isEqualToString:@"goods"]) {
            [cell.good setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"bads"]) {
            
            [cell.bad setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
        }else {
            
            [cell.comment setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
        }
    }];
    
    [stepVc setHidesBottomBarWhenPushed:YES];
    AVObject *obj = self.meumArray[indexPath.section];
    stepVc.avObj = obj;
    [self.navigationController pushViewController:stepVc animated:YES];
}

@end
