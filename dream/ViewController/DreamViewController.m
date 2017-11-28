//
//  DreamViewController.m
//  dream
//
//  Created by zhy on 17/1/13.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "DreamViewController.h"
#import "MeumView.h"
#import "MeumParams.h"
#import "MeumModel.h"
#import "StepModel.h"
#import "TableCell.h"
#import "CellLayout.h"
#import "ResuableView.h"
#import "CollectionCell.h"
#import "StepViewController.h"
@interface DreamViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)MeumView *meumView;
@property (nonatomic,strong)NSString *className;
@property (nonatomic,strong)NSMutableArray *meumArray;

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UICollectionView *collection;;

@property (nonatomic,strong)UIButton *topBtn;


//@property (nonatomic,strong)MeumParams *meumParams;

@end

@implementation DreamViewController

-(UIButton *)topBtn {

    if (_topBtn == nil) {
        
        self.topBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, kScreenHeight-49-60, 50, 50)];
        self.topBtn.clipsToBounds = YES;
        self.topBtn.layer.cornerRadius = 25;
        self.topBtn.backgroundColor = [UIColor brownColor];
        [self.topBtn setTitle:@"⇧" forState:UIControlStateNormal];
        [self.topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.topBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [self.topBtn addTarget:self action:@selector(tableToTop) forControlEvents:UIControlEventTouchUpInside];
        self.topBtn.alpha = 0;
    }
    return _topBtn;
}

-(UICollectionView *)collection {

    if (_collection == nil) {
        
        self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64) collectionViewLayout:[[CellLayout alloc]init]];
        self.collection.dataSource      = self;
        self.collection.delegate        = self;
        self.collection.backgroundColor = [UIColor fromHexValue:0xDFDFDF alpha:0.5];
//        [self.collection registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"MY_CELL"];//注册item或cell
        [self.collection registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MY_CELL"];
        //刷新
        self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [SVProgressHUD show];
            
            AVQuery *query = [AVQuery queryWithClassName:@"meum"];
            [query whereKey:@"type" equalTo:self.className];
            query.limit = 10;// 最多返回 10 条结果
            query.skip = 0;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                [self.meumArray removeAllObjects];
                [self.meumArray addObjectsFromArray:objects];
                
                [self.collection reloadData];
                
                [self.collection.mj_header endRefreshing];
                
                [SVProgressHUD dismiss];
                
            }];
        }];
        
        //加载
        self.collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [SVProgressHUD show];
            
            AVQuery *query = [AVQuery queryWithClassName:@"meum"];
            [query whereKey:@"type" equalTo:self.className];
            query.limit = 10;// 最多返回 10 条结果
            query.skip = self.meumArray.count;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                [self.meumArray addObjectsFromArray:objects];
                
                [self.collection reloadData];
                
                [self.collection.mj_footer endRefreshing];
                
                [SVProgressHUD dismiss];
            }];
        }];
    }
    return _collection;
}

-(UITableView *)table {

    if (_table == nil) {
        
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64)];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.tableFooterView = [UIView new];
        self.table.estimatedRowHeight = 100;
        self.table.rowHeight = UITableViewAutomaticDimension;
        
        //刷新
        self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [SVProgressHUD show];
            
            AVQuery *query = [AVQuery queryWithClassName:@"meum"];
            [query whereKey:@"type" equalTo:self.className];
            query.limit = 10;// 最多返回 10 条结果
            query.skip = 0;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                [self.meumArray removeAllObjects];
                [self.meumArray addObjectsFromArray:objects];
                
                [self.table reloadData];
                
                [self.table.mj_header endRefreshing];
                
                [SVProgressHUD dismiss];
                
            }];
        }];
        
        //加载
        self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

            [SVProgressHUD show];
            
            AVQuery *query = [AVQuery queryWithClassName:@"meum"];
            [query whereKey:@"type" equalTo:self.className];
            query.limit = 10;// 最多返回 10 条结果
            query.skip = self.meumArray.count;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                [self.meumArray addObjectsFromArray:objects];
                
                [self.table reloadData];
                
                [self.table.mj_footer endRefreshing];
                
                [SVProgressHUD dismiss];
            }];
            
        }];
    }
    return _table;
}

-(MeumView *)meumView {

    if (_meumView == nil) {
        
        self.meumView = [[MeumView alloc]initWithFrame:CGRectMake(-90, 0, 90, kScreenHeight-49-64)];
        [self.meumView returnTapedMeum:^(NSString *title, NSString *className) {
            
            self.title = title;
            [self showMeum];
            self.className = className;
            
            if (_table) {
             
                [self.table.mj_header beginRefreshing];
                
            }else {
            
                [self.collection.mj_header beginRefreshing];
            }
        }];
    }
    return _meumView;
}

-(NSMutableArray *)meumArray {

    if (_meumArray == nil) {
        
        self.meumArray = [NSMutableArray array];
    }
    return _meumArray;
}

//-(MeumParams *)meumParams {
//
///*
//   1  家常菜",
//   3  @"创意菜"
//   4 ,@"素菜"
//   5 ,@"凉菜"
//   6 ,@"烘培"
//   7 ,@"面食"
//   8 ,@"汤"
//   9 ,@"自制调味
// */
//    if (_meumParams == nil) {
//        self.meumParams = [[MeumParams alloc]init];
//        self.meumParams.cid = @"9";
//        self.meumParams.pn = @"0";
//    }
//    return _meumParams;
//}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    if (_topBtn) {
        [_topBtn removeFromSuperview];
        _topBtn = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_meumView removeFromSuperview];
    _meumView = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"家常菜";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.className = jiachangcai;

    
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [itemBtn addTarget:self action:@selector(showMeum) forControlEvents:UIControlEventTouchUpInside];
    [itemBtn setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
    UIBarButtonItem *leftMeum = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    self.navigationItem.leftBarButtonItem = leftMeum;
    
    
    UIButton *rightBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn1 addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 setImage:[UIImage imageNamed:@"table"] forState:UIControlStateNormal];
    UIBarButtonItem *rightMeum1 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn1];
    
    UIButton *rightBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn2 addTarget:self action:@selector(showCollect) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn2 setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    UIBarButtonItem *rightMeum2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn2];
    
    self.navigationItem.rightBarButtonItems = @[rightMeum1,rightMeum2];
    
    [self.view addSubview:self.table];
    [self.table.mj_header beginRefreshing];

}

//table展示
- (void)showTable {
    
    if (_collection) {
        
        [_collection removeFromSuperview];
        _collection = nil;
        
        [self.view addSubview:self.table];
        [self.table reloadData];
    }
    
//    self.meumParams.pn = [NSString stringWithFormat:@"%ld",[self.meumParams.pn integerValue] + 20];
//    [self requestData];
    
}

//collect展示
- (void)showCollect {

    if (_table) {
     
        [_table removeFromSuperview];
        _table = nil;
        
        [self.view addSubview:self.collection];
        [self.collection reloadData];
    }
}

//table回滚
- (void)tableToTop {

    [self.table setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)showMeum {
    
//    for (MeumModel *MM in self.meumArray) {
//        
//        AVObject *obj = [AVObject objectWithClassName:@"meum"];
//        [obj setObject:self.meumParams.cid forKey:@"type"]; //类型
//        [obj setObject:MM.title forKey:@"title"];      //菜名
//        [obj setObject:MM.tags forKey:@"tags"];        //标签
//        [obj setObject:MM.imtro forKey:@"imtro"];      //简介
//        [obj setObject:MM.ingredients forKey:@"ingredients"]; //主材
//        [obj setObject:[MM.albums[0] stringByReplacingOccurrencesOfString:@"\\" withString:@""] forKey:@"albums"]; //大图
//        [obj setObject:@"0" forKey:@"bads"];
//        [obj setObject:@"0" forKey:@"comments"];
//        [obj setObject:@"0" forKey:@"goods"];
//        [obj setObject:MM.burden forKey:@"burden"]; //辅材
//
//        NSMutableArray *mutable = [NSMutableArray array];
//        for (StepModel *SM in MM.steps) {
//            [mutable addObject:SM.mj_keyValues];
//        }
//        [obj setObject:mutable forKey:@"steps"];
//        
//        if ([obj save]) {
//            NSLog(@"存储成功");
//        }else {
//
//            NSLog(@"失败的话");
//        }
//    }
    
//        for (StepModel *SM in MM.steps) {
//    
//            NSString *imageStr = [SM.img stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//            AVFile *file =[AVFile fileWithURL:imageStr];
//            [file getData];// 注意这一步很重要，这是把图片从原始地址拉去到本地
//            
//            if ([file save]) {
//                NSLog(@"image存储成功");
//            }else {
//            
//                NSLog(@"image存储失败");
//            }
//        }
//    }
    
    if (_meumView == nil) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.view addSubview:self.meumView];
            self.meumView.frame = CGRectMake(0, 0, 90, kScreenHeight-49-64);
            
            
        } completion:nil];
        
    }else {
    
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.meumView.frame = CGRectMake(-90, 0, 90, kScreenHeight-49-64);
            
            
        } completion:^(BOOL finished) {
            
            [_meumView removeFromSuperview];
            _meumView = nil;
            
        }];
    }
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
    
    //评分  算平均分
    NSArray *stars = obj[@"stars"];
    float allStar = 0;
    for (NSString *star in stars) {
        
        allStar += [star floatValue];
    }
    cell.ratingView.rate = allStar/stars.count;
    
    //大图
    NSString *urlStr = obj[@"albums"];;
    if([urlStr rangeOfString:@"http"].location !=NSNotFound) {
    
        //通过url获取
        AVFile *file = [AVFile fileWithURL:urlStr];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                cell.meumImg.image = [UIImage imageWithData:data];
            }
        } progressBlock:^(NSInteger percentDone) {
            //下载的进度数据，percentDone 介于 0 和 100。
        }];
        
        //没有图
    }else if ([urlStr rangeOfString:@"xoxoxo"].location != NSNotFound) {
    
        cell.meumImg.image = [UIImage imageNamed:@"加价小图"];
        
    }else {
        //通过objectId获取
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
    
    //主材
    cell.introLabel.text = obj[@"imtro"];
    //菜名
    cell.titleLabel.text = obj[@"title"];
    //评论
    [cell.comment setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"comments"]).count] forState:UIControlStateNormal];
    //点赞
    [cell.good setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"goods"]).count] forState:UIControlStateNormal];
    //踩
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
    
    AVObject *obj = self.meumArray[indexPath.section];
    stepVc.avObj = obj;
    [stepVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:stepVc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.table.contentOffset.y > 0) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.topBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.topBtn.alpha = 1;
        }];
        
    }else {
    
        [UIView animateWithDuration:0.4 animations:^{
            
            self.topBtn.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [_topBtn removeFromSuperview];
            _topBtn = nil;
        }];
    }
}

#pragma mark UICollectionDelegate&&DataSource
//必须实现，返回每个section中item的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.meumArray.count;
}

//必须实现，返回每个item的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:self options:nil] lastObject];
    }
    
    
    AVObject *obj = self.meumArray[indexPath.row];
    
    //大图
    NSString *urlStr = obj[@"albums"];;
    if([urlStr rangeOfString:@"http"].location !=NSNotFound) {
        
        //通过url获取
        AVFile *file = [AVFile fileWithURL:urlStr];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                cell.meumImg.image = [UIImage imageWithData:data];
            }
        } progressBlock:^(NSInteger percentDone) {
            //下载的进度数据，percentDone 介于 0 和 100。
        }];
        
        //没有图
    }else if ([urlStr rangeOfString:@"xoxoxo"].location != NSNotFound) {
        
        cell.meumImg.image = [UIImage imageNamed:@"加价小图"];
        
    }else {
        //通过objectId获取
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
    
    cell.titleLabel.text = obj[@"title"];
    [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"comments"]).count] forState:UIControlStateNormal];
    [cell.goodBtn setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"goods"]).count] forState:UIControlStateNormal];
    [cell.badBtn setTitle:[NSString stringWithFormat:@"%ld",((NSArray *)obj[@"bads"]).count] forState:UIControlStateNormal];
    
    return cell;
}

//返回section数量
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    StepViewController *stepVc = [StepViewController new];
    
    
    [stepVc repeatCountBlock:^(NSInteger count, NSString *type) {
        
        CollectionCell *cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([type isEqualToString:@"goods"]) {
            [cell.goodBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"bads"]) {
            
            [cell.badBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
        }
    }];
    
    AVObject *obj = self.meumArray[indexPath.row];
    [stepVc setHidesBottomBarWhenPushed:YES];
    stepVc.avObj = obj;
    [self.navigationController pushViewController:stepVc animated:YES];
    
}

//- (void)requestData {
//
//    NSLog(@"self.meumParams.mj_keyValues = %@",self.meumParams.mj_keyValues);
//    
//    [KSMNetworkRequest postRequest:requestMeumUrl params:self.meumParams.mj_keyValues success:^(id responseObj) {
//        
//        NSDictionary *dic = (NSDictionary *)responseObj;
//        
//        if ([[dic objectForKey:@"error_code"] integerValue] == 0) {
//            NSLog(@"dic = %@",dic);
//            
//            NSArray *array = [MeumModel mj_objectArrayWithKeyValuesArray:dic[@"result"][@"data"]];
//            [self.meumArray addObjectsFromArray:array];
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

@end
