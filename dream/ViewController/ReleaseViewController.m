//
//  ReleaseViewController.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ReleaseHeadCell.h"
#import "FillLabelView.h"
#import "ReleaseStepView.h"
#import "MeumView.h"
#import "PwdLoginViewController.h"
@interface ReleaseViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *zhuArray;
    NSMutableArray *fuArray;
    FillLabelView *fillView1;
    FillLabelView *fillView2;
    NSInteger    rows;
    NSMutableArray *contents;
    NSMutableArray *images;
    //大图
    NSMutableArray  *albums;
    //类名
    NSString *ClassName;
    //菜类型
    NSString *typeName;
    //菜名
    NSString *Title;
    //介绍
    NSString *imtro;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIButton *circleDelete;
@end


@implementation ReleaseViewController

-(UIButton *)circleDelete {
    
    if (_circleDelete == nil) {
        
        self.circleDelete = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, kScreenHeight-49-50-30, 50, 50)];
        self.circleDelete.backgroundColor = [UIColor brownColor];
        self.circleDelete.layer.cornerRadius = 25;
        [self.circleDelete setTitle:@"发布" forState:UIControlStateNormal];
        [self.circleDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.circleDelete addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleDelete;
}

- (void)releaseAction {

    if (ClassName.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择类型" delay:DELAY];
        return;
    }
    
    if (Title.length == 0) {
        [[HUDConfig shareHUD]Tips:@"菜名忘记写啦！" delay:DELAY];
        return;
    }
    
    if (zhuArray.count == 0) {
        [[HUDConfig shareHUD]Tips:@"主材别忘记了！" delay:DELAY];
        return;
    }
    
    if ([Uitils some:contents content:@"暂无"]) {
        [[HUDConfig shareHUD]Tips:@"请完善步骤" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    
    //上传大图
    if (albums.count > 0) {
        
        UIImage *bigImg = albums[0];
        AVFile *bigFile = [AVFile fileWithData:UIImagePNGRepresentation(bigImg)];
        [bigFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            NSLog(@"%@",bigFile.objectId);
            [self postData:bigFile.objectId];
        }];
        
        return;
    }
    
    [self postData:@""];
}

- (void)postData:(NSString *)albumsID {

    AVObject *obj = [AVObject objectWithClassName:@"meum"];
    [obj setObject:ClassName forKey:@"type"]; //类型
    [obj setObject:Title forKey:@"title"]; //标题
    if (imtro.length > 0) {
        [obj setObject:imtro forKey:@"imtro"]; //简介
    }
    [obj setObject:[zhuArray componentsJoinedByString:@";"] forKey:@"ingredients"];//主材
    
    if (albumsID.length > 0) {
     [obj setObject:albumsID forKey:@"albums"];//大图
    }
    if (fuArray.count > 0) {
        
        [obj setObject:[fuArray componentsJoinedByString:@";"] forKey:@"burden"]; //辅材
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<contents.count; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:contents[i] forKey:@"step"];
        
        if ([images[i] isKindOfClass:[UIImage class]]) {
            UIImage *stepImg = images[i];
            AVFile *stepFile = [AVFile fileWithData:UIImagePNGRepresentation(stepImg)];
            [stepFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                NSLog(@"%@",stepFile.objectId);
                [dic setObject:stepFile.objectId forKey:@"img"];
            }];
            
        }else {
            [dic setObject:@"xoxoxo" forKey:@"img"];
        }
        
        [array addObject:dic];
    }
    
    [obj setObject:array forKey:@"steps"];
    
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            NSLog(@"存储成功");
            
            AVUser *user = [AVUser currentUser];
            NSMutableArray *release = [NSMutableArray arrayWithArray:user[@"release"]];
            [release addObject:obj.objectId];
            [user setObject:release forKey:@"release"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [[HUDConfig shareHUD]SuccessHUD:nil delay:DELAY];
                    
                    NSString *expri = user[@"experience"];
                    expri = [NSString stringWithFormat:@"%d",[expri intValue] + 5];
                    [user setObject:expri forKey:@"experience"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if (succeeded) {
                            NSLog(@"存储成功");
                            
                            [[HUDConfig shareHUD]SuccessHUD:@"发布成功" delay:DELAY];
                            
                        }else {
                        
                            NSLog(@"存储失败");
                            [[HUDConfig shareHUD]SuccessHUD:@"发布失败" delay:DELAY];
                            
                        }
                    }];
                }
            }];
            
        }else {
        
            NSLog(@"失败的话 = %@",error.localizedDescription);
            [[HUDConfig shareHUD]dismiss];
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    rows = 1;
    zhuArray = [NSMutableArray array];
    fuArray = [NSMutableArray array];
    contents = [NSMutableArray arrayWithObject:@"暂无"];
    images = [NSMutableArray arrayWithObject:@"暂无"];
    albums = [NSMutableArray array];
    
    fillView1 = [[FillLabelView alloc] initWithFrame:CGRectMake(35, 50, kScreenWidth-40, 300)];
    fillView1.sizeFont = [UIFont boldSystemFontOfSize:15];
    fillView1.padd = 8;
    
    fillView2 = [[FillLabelView alloc] initWithFrame:CGRectMake(35, 50, kScreenWidth-40, 300)];
    fillView2.sizeFont = [UIFont boldSystemFontOfSize:15];
    fillView2.padd = 8;
    self.title = @"作品发布";
    [self  initSubViews];
    
    [self.view addSubview:self.circleDelete];
}

- (void)initSubViews {
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorColor = [UIColor clearColor];
    //    self.table.estimatedRowHeight = 100;
    //    self.table.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.table];
    

}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
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
    }
}

#pragma mark UITableViewDelegate&&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return rows;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 4) {
        
        ReleaseStepView *head = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseStepView" owner:self options:nil] lastObject];
        return head;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            
            return 100;
            break;
        case 1:
            
            return 120;
            break;
        case 2: {
        
            if (zhuArray.count == 0) {
                return 80;
            }
            CGFloat height = [fillView1 bindTags:zhuArray];
            return height+60;
        }
            break;
        case 3:{
            
            if (fuArray.count == 0) {
                return 80;
            }
            CGFloat height = [fillView2 bindTags:fuArray];
            return height+60;
        }
            break;
        case 4:
            
            return 80;
            break;
            
        default:
            break;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
        
            ReleaseHeadCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReleaseHeadCell" owner:self options:nil][0];
            
            __weak ReleaseHeadCell *selfCell = cell;
            
            //设置菜名
            [cell setStepContentBack:^(NSString *content) {
                
                Title  = content;
            }];
            
            //设置图片
            [cell takePhotoBack:^{
                
                TakePhotoViewController *TakePhoto = [[TakePhotoViewController alloc]init];
                [TakePhoto returnImage:^(UIImage *image) {
                    
                    cell.meumImg.image = image;
                    [albums removeAllObjects];
                    [albums addObject: image];
                }];
                [self presentViewController:TakePhoto animated:YES completion:nil];
            }];
            
            //选择类型
            [cell returnHeight:^(NSString *content) {
                
                MeumView *meumView = [[MeumView alloc]initWithFrame:CGRectMake(selfCell.typeButton.origin.x, selfCell.typeButton.origin.y+selfCell.typeButton.height+64, selfCell.typeButton.width, kScreenHeight-(selfCell.typeButton.origin.y+selfCell.typeButton.height+64+49))];
                [self.view addSubview:meumView];
                [meumView returnTapedMeum:^(NSString *title, NSString *className) {
                    
                    typeName  = title;
                    ClassName = className;
                    [selfCell.typeButton setTitle:title forState:UIControlStateNormal];
                    
                    [meumView removeFromSuperview];
                }];
            }];
            
            
            //类型
            if (typeName.length > 0) {
                
                [cell.typeButton setTitle:typeName forState:UIControlStateNormal];
            }
            
            //图片
            if (albums.count > 0) {
                
                cell.meumImg.image = albums[0];
            }
            
            //菜名
            if (Title) {
                cell.meumNameTF.text = Title;
            }
            
            return cell;
        }
            break;
            
        case 1:{
            
            ReleaseHeadCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReleaseHeadCell" owner:self options:nil][1];
            //设置简介
            [cell setStepContentBack:^(NSString *content) {
                
                imtro = content;
            }];
            
            if (imtro) {
             
                cell.contentTV.text = imtro;
            }
            
            return cell;
        }
            break;
        case 2:{
            
            ReleaseHeadCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReleaseHeadCell" owner:self options:nil][2];
            cell.cellName.text = @"主材";
            cell.tag = 200;
            
            [cell returnHeight:^(NSString *content) {
                
                [zhuArray addObject:content];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [cell.contentView addSubview:fillView1];
            return cell;
        }
            break;
        case 3:{
            
            ReleaseHeadCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReleaseHeadCell" owner:self options:nil][2];
            cell.cellName.text = @"辅材";
            cell.tag = 300;
            cell.starLabel.hidden = YES;
            [cell returnHeight:^(NSString *content) {
                
                [fuArray addObject:content];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [cell.contentView addSubview:fillView2];
            return cell;
        }
            break;
            
        case 4:{
            
            ReleaseHeadCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReleaseHeadCell" owner:self options:nil][3];
            cell.setpNumLabel.text = [NSString stringWithFormat:@"步骤%ld",indexPath.row+1];
            
            if ([images[indexPath.row] isKindOfClass:[UIImage class]]) {
             
                cell.setpImg.image = images[indexPath.row];
            }
            
            if (![contents[indexPath.row] isEqualToString:@"暂无"]) {
                
                cell.stepContent.text = contents[indexPath.row];
            }
            
            //设置内容
            [cell setStepContentBack:^(NSString *content) {
                
                [contents replaceObjectAtIndex:indexPath.row withObject:content];
            }];
            
            //设置图片
            [cell takePhotoBack:^{
                
                TakePhotoViewController *TakePhoto = [[TakePhotoViewController alloc]init];
                [TakePhoto returnImage:^(UIImage *image) {
                    
                    cell.setpImg.image = image;
                    [images replaceObjectAtIndex:indexPath.row withObject:image];
                    
                }];
                [self presentViewController:TakePhoto animated:YES completion:nil];
            }];
            
            [cell addSetpBack:^(NSString *type) {
               
                if ([type isEqualToString:@"add"]) {
                    
                    rows = rows + 1;
                    [contents addObject:@"暂无"];
                    [images addObject:@"暂无"];
                   
                }else {
                
                    rows = rows - 1;
                    [contents removeObjectAtIndex:indexPath.row];
                    [images removeObjectAtIndex:indexPath.row];
                }
                
                NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:4];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            if (rows > 1) {
                
                if (indexPath.row == rows-1) {
                    
                    cell.add_reduceBtn.selected = NO;
                }else {
                
                    cell.add_reduceBtn.selected = YES;
                }
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}


@end
