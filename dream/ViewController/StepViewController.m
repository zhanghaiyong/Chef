//
//  StepViewController.m
//  dream
//
//  Created by 张海勇 on 2017/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "StepViewController.h"
#import "StepHeadCell.h"
#import "StepHeadView.h"
#import "AssistCell.h"
#import "FillLabelView.h"
#import "StepsCell.h"
#import "MeumCommentCell.h"
#import "CommentViewController.h"
#import "PwdLoginViewController.h"
@interface StepViewController ()<UITableViewDelegate,UITableViewDataSource>{

    FillLabelView *fillView1;
    FillLabelView *fillView2;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSArray *stepArray;
//@property (nonatomic, strong) UIButton *collectionBtn;
@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = self.avObj[@"title"];

    self.stepArray = [NSArray arrayWithArray:self.avObj[@"steps"]];
    
    [self initSubViews];
}

- (void)initSubViews {

    fillView1 = [[FillLabelView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 300)];
    fillView1.sizeFont = [UIFont boldSystemFontOfSize:15];
    fillView1.padd = 8;
    
    fillView2 = [[FillLabelView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 300)];
    fillView2.sizeFont = [UIFont boldSystemFontOfSize:15];
    fillView2.padd = 8;

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorColor = [UIColor clearColor];
//    self.table.estimatedRowHeight = 100;
//    self.table.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.table];
    
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [collectionBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    
    AVUser *user = [AVUser currentUser];
    NSMutableArray *collection = [NSMutableArray arrayWithArray:user[@"collect"]];
    
    //判断此用户是否对此菜进行过收藏
    if ([collection containsObject:self.avObj[@"objectId"]]) {
        
        collectionBtn.selected = YES;
    }
    [collectionBtn addTarget:self action:@selector(tapCollectionAction:)forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:collectionBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)tapCollectionAction:(UIButton *)sender {

    
    if ([AVUser currentUser]) {
        
        UIButton *button = (UIButton *)sender;
        if (button.selected) {
            
            [[HUDConfig shareHUD]Tips:@"已收藏" delay:DELAY];
            
        }else {
            
            AVUser *user = [AVUser currentUser];
            button.selected = YES;
            NSMutableArray *collection = [NSMutableArray arrayWithArray:user[@"collection"]];
            [collection addObject:self.avObj[@"objectId"]];
            [user setObject:collection forKey:@"collection"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    
                    //收藏成功过后，用户经验加2
                    NSString *expri = user[@"experience"];
                    expri = [NSString stringWithFormat:@"%d",[expri intValue] + 2];
                    [user setObject:expri forKey:@"experience"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        self.avObj.fetchWhenSave = true;
                        if (succeeded) {
                            [[HUDConfig shareHUD]SuccessHUD:@"收藏成功" delay:DELAY];
                        }else {
                            
                            [[HUDConfig shareHUD]SuccessHUD:@"收藏失败" delay:DELAY];
                        }
                        
                    }];
                }else {
                    
                    [[HUDConfig shareHUD]SuccessHUD:@"收藏失败" delay:DELAY];
                }
            }];
        }
    }else {
        
        [self showAlert];
    }
}


#pragma mark UITableViewDelegate&&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3: {
            
            return self.stepArray.count;
        }
            break;
        case 4: {
            
            return 1;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 35;
            break;
        case 2:
            return 35;
            break;
        case 3:
            return 35;
            break;
        case 4:
            return 10;
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *headImg;
    NSString *headName;
    
    switch (section) {
        case 1: //主材
            headImg = @"主";
            headName = @"主材";
            break;
        case 2: //辅材
            headImg = @"辅";
            headName = @"辅材";
            break;
        case 3: //步骤
            headImg = @"步骤";
            headName = @"做法步骤";
            break;
            
        default:
            break;
    }
    
    StepHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"StepHeadView" owner:self options:nil] lastObject];
    headView.frame = CGRectMake(0, 0, kScreenWidth, 35);
    headView.headImg.image = [UIImage imageNamed:headImg];
    headView.headLabel.text = headName;
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:{
            
            NSString *introStr = self.avObj[@"imtro"];
            CGRect introFrame = [[NSString stringWithFormat:@"  %@",introStr] boundingRectWithSize:CGSizeMake(kScreenWidth-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            return introFrame.size.height+145;
        }
            break;
            
        case 1:{
            
            NSString *ingredients = self.avObj[@"ingredients"];
            NSMutableArray *tags = [[NSMutableArray alloc]initWithArray:[ingredients componentsSeparatedByString:@";"]];
            CGFloat height = [fillView1 bindTags:tags];
            return height+20;
        }
            break;
            
        case 2: {
        
            NSString *burden = self.avObj[@"burden"];
            NSMutableArray *tags = [[NSMutableArray alloc]initWithArray:[burden componentsSeparatedByString:@";"]];
            CGFloat height = [fillView2 bindTags:tags];
            return height+20;
        }
            break;
            
        case 3:{
        
            NSDictionary *albums = self.stepArray[indexPath.row];
            CGRect stepFrame = [[[albums objectForKey:@"step"] substringFromIndex:2] boundingRectWithSize:CGSizeMake(kScreenWidth-110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            
            if ((stepFrame.size.height+15) < 80) {
                
                return 80;
            }else {
            
                return stepFrame.size.height + 30;
            }
        }
            break;
        case 4: {
            
            return 60;
        }
            
        default:
            break;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
    
            StepHeadCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"StepHeadCell" owner:self options:nil] lastObject];
            
            NSString *urlStr = self.avObj[@"albums"];
            
            if([urlStr rangeOfString:@"http"].location !=NSNotFound) {
        
                AVFile *file = [AVFile fileWithURL:urlStr];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    
                    cell.meumImg.image = [UIImage imageWithData:data];
                    
                } progressBlock:^(NSInteger percentDone) {
                    //下载的进度数据，percentDone 介于 0 和 100。
                }];
            }else if ([urlStr rangeOfString:@"xoxoxo"].location !=NSNotFound) {
            
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
        
            
            //星评
            NSArray *stars = self.avObj[@"stars"];
            float allStar = 0;
            for (NSString *star in stars) {
                
                allStar += [star floatValue];
            }
            cell.ratingView.rate = allStar/stars.count;
            
            NSString *ingredients = self.avObj[@"tags"];
            NSMutableArray *tags = [[NSMutableArray alloc]initWithArray:[ingredients componentsSeparatedByString:@";"]];
            [cell.fillView bindTags:tags];
            
            cell.introLabel.text = [NSString stringWithFormat:@"  %@",self.avObj[@"imtro"]];
            cell.titleLabel.text = self.avObj[@"title"];
            
            return cell;
        }
            break;
            
        case 1: {
        
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.contentView addSubview:fillView1];
            return cell;
        }
            break;
            
        case 2: {
        
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.contentView addSubview:fillView2];
            return cell;
        }
            break;
            
        case 3: {
            
            StepsCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"StepsCell" owner:self options:nil] lastObject];
            
            //放大图片
            [cell returnBigImageBlock:^(UIImage *img) {
                
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:@[[MWPhoto photoWithImage:img]]];
                browser.displayActionButton = NO;//分享按钮,默认是
                browser.displayNavArrows = NO;//左右分页切换,默认否
                browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
                browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
                browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
                browser.wantsFullScreenLayout = NO;//是否全屏
#endif
                browser.enableGrid = YES;//是否允许用网格查看所有图片,默认是
                browser.startOnGrid = NO;//是否第一张,默认否
                browser.enableSwipeToDismiss = YES;
                [browser showNextPhotoAnimated:YES];
                [browser showPreviousPhotoAnimated:YES];
                [browser setCurrentPhotoIndex:0];
                
                [self.navigationController pushViewController:browser animated:YES];
                
            }];
            
            NSDictionary *albums = self.stepArray[indexPath.row];
            
            AVFile *file = [AVFile fileWithURL:[albums objectForKey:@"img"]];
            
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                cell.meumImg.image = [UIImage imageWithData:data];
                
            } progressBlock:^(NSInteger percentDone) {
                //下载的进度数据，percentDone 介于 0 和 100。
            }];
            
            cell.stepIntroLabel.text = [[albums objectForKey:@"step"] substringFromIndex:2];
            cell.numLabel.text = [NSString stringWithFormat:@"步骤%ld",indexPath.row+1];
            return cell;
        }
            break;
        case 4: {
            
            MeumCommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MeumCommentCell" owner:self options:nil] lastObject];
            
            AVUser *user = [AVUser currentUser];
            
            //获取此菜的评论数 点赞数 踩过数
           __block NSMutableArray *goods = [NSMutableArray arrayWithArray:self.avObj[@"goods"]];
           __block NSMutableArray *bads = [NSMutableArray arrayWithArray:self.avObj[@"bads"]];
            __block NSMutableArray *comments = [NSMutableArray arrayWithArray:self.avObj[@"comments"]];
            
            [cell.goodBtn setTitle:[NSString stringWithFormat:@"%ld",goods.count] forState:UIControlStateNormal];
            [cell.badBtn setTitle:[NSString stringWithFormat:@"%ld",bads.count] forState:UIControlStateNormal];
            [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld",comments.count] forState:UIControlStateNormal];
            
            //此用户是否已经赞过
            if ([goods containsObject:user[@"objectId"]]) {
                
                cell.goodBtn.userInteractionEnabled = NO;
                cell.goodBtn.alpha = 1;
            }else {
            
                cell.goodBtn.userInteractionEnabled = YES;
                cell.goodBtn.alpha = 0.4;
            }
            
            //此用户是否已经踩过
            if ([bads containsObject:user[@"objectId"]]) {
                
                cell.badBtn.userInteractionEnabled = NO;
                cell.badBtn.alpha = 1;
            }else {
                
                cell.badBtn.userInteractionEnabled = YES;
                cell.badBtn.alpha = 0.4;
            }
            
            [cell tapWitchBtnBlock:^(NSInteger tags) {
                
                switch (tags) {
                    case 100: {
                    
                        CommentViewController *commentVC = [CommentViewController new];
                        commentVC.avObj = self.avObj;
                        
                        [commentVC repeatCommentCount:^(NSInteger count) {
                           
                            [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
                            
                            self.renewCountBlock(count,@"comments");
                            
                        }];
                        
                        [self.navigationController pushViewController:commentVC animated:YES];
                    }
                        
                        break;
                    case 101: {
                    
                        
                        if ([AVUser currentUser]) {
                            //点赞
                            [goods addObject:user[@"objectId"]];
                            [self.avObj setObject:goods forKey:@"goods"];
                            [self.avObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (succeeded) {
                                    
                                    //成功过后，更新用户的likes字段
                                    NSMutableArray *likes = [NSMutableArray arrayWithArray:user[@"likes"]];
                                    [likes addObject:self.avObj[@"objectId"]];
                                    [user setObject:likes forKey:@"likes"];
                                    [user saveInBackground];
                                    
                                    //成功过后，用户经验加2
                                    NSString *expri = user[@"experience"];
                                    expri = [NSString stringWithFormat:@"%d",[expri intValue] + 2];
                                    [user setObject:expri forKey:@"experience"];
                                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        
                                        self.avObj.fetchWhenSave = true;
                                        
                                    }];
                                    
                                    [[HUDConfig shareHUD] SuccessHUD:@"赞了一下" delay:DELAY];
                                    cell.goodBtn.alpha = 1;
                                    cell.goodBtn.userInteractionEnabled = NO;
                                    
                                    // 保存时自动取回云端最新数据
                                    self.avObj.fetchWhenSave = true;
                                    goods = self.avObj[@"goods"];
                                    [cell.goodBtn setTitle:[NSString stringWithFormat:@"%ld",goods.count] forState:UIControlStateNormal];
                                    //回掉 更新数据
                                    self.renewCountBlock(goods.count,@"goods");
                                    
                                }else {
                                    
                                    NSLog(@"失败");
                                }
                            }];
                        }else {
                        
                            [self showAlert];
                        }
                        

                    }
                        break;
                        
                    case 102: {
                        
                        if ([AVUser currentUser]) {
                            
                            //踩
                            [bads addObject:user[@"objectId"]];
                            [self.avObj setObject:bads forKey:@"bads"];
                            [self.avObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (succeeded) {
                                    
                                    //成功后，更新用户dislikes字段
                                    NSMutableArray *dislikes = [NSMutableArray arrayWithArray:user[@"dislikes"]];
                                    [dislikes addObject:self.avObj[@"objectId"]];
                                    [user setObject:dislikes forKey:@"dislikes"];
                                    [user saveInBackground];
                                    
                                    //经验加2
                                    NSString *expri = user[@"experience"];
                                    expri = [NSString stringWithFormat:@"%d",[expri intValue] + 2];
                                    [user setObject:expri forKey:@"experience"];
                                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        
                                        self.avObj.fetchWhenSave = true;
                                        
                                    }];
                                    
                                    [[HUDConfig shareHUD] SuccessHUD:@"踩了一脚" delay:DELAY];
                                    cell.badBtn.alpha = 1;
                                    cell.badBtn.userInteractionEnabled = NO;
                                    
                                    // 保存时自动取回云端最新数据
                                    self.avObj.fetchWhenSave = true;
                                    bads = self.avObj[@"bads"];
                                    [cell.badBtn setTitle:[NSString stringWithFormat:@"%ld",bads.count] forState:UIControlStateNormal];
                                    self.renewCountBlock(bads.count,@"bads");
                                    
                                }else {
                                    
                                    NSLog(@"失败");
                                }
                            }];
                        }else {
                        
                            [self showAlert];
                        }
                    }
                        
                        break;
                    default:
                        break;
                }
                
            }];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
    
}

- (void)showAlert {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未登录状态不能发布菜品，是否登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"暂不登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (void)repeatCountBlock:(RenewCountBlock)block {

    _renewCountBlock = block;
}


@end
