//
//  CommentViewController.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "CommentsView.h"
#import "PwdLoginViewController.h"
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{

    CommentsView *commentView;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *commentData;

@end

@implementation CommentViewController


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    if ([AVUser currentUser]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentsView" owner:self options:nil] lastObject];
        commentView.frame = CGRectMake(0, self.table.bottom, kScreenWidth, 50);
        [commentView releseCommentCallback:^(NSString *s, NSDictionary *commentDic) {
            
            NSMutableArray *comments = [NSMutableArray arrayWithArray:self.avObj[@"comments"]];
            NSMutableArray *stars = [NSMutableArray arrayWithArray:self.avObj[@"stars"]];
            [comments addObject:commentDic];
            [stars addObject:s];
            
            [self.avObj setObject:comments forKey:@"comments"];
            [self.avObj setObject:stars forKey:@"stars"];
            [self.avObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    commentView.content.text = @"  说点什么吧";
                    
                    self.avObj.fetchWhenSave = true;
                    
                    self.commentData = self.avObj[@"comments"];
                    
                    self.successCommentCallBack(self.commentData.count);
                    
                    [self.table reloadData];
                    
                    
                    AVUser *user = [AVUser currentUser];
                    NSString *expri = user[@"experience"];
                    expri = [NSString stringWithFormat:@"%d",[expri intValue] + 2];
                    [user setObject:expri forKey:@"experience"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        self.avObj.fetchWhenSave = true;
                        
                    }];
                }
            }];
            
        }];
        [self.view addSubview:commentView];
    }else {
        
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

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentData = [NSMutableArray arrayWithArray:self.avObj[@"comments"]];
    
    self.title = @"评论";

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubView];
}

- (void)initSubView {

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorInset = UIEdgeInsetsMake(0, -80, 0, -80);
    self.table.tableFooterView = [UIView new];
    //    self.table.estimatedRowHeight = 100;
    //    self.table.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.table];
}


/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        commentView.frame = CGRectMake(0, kScreenHeight-140-frame.size.height, kScreenWidth, 140);
        
        commentView.ratingView.rate = 5;
        commentView.cancleH.constant = 40;
        commentView.cancleBtn.alpha = 1;
        commentView.sureBtn.alpha = 1;
        commentView.ratingView.alpha = 1;
        commentView.content.layer.borderColor  =[UIColor clearColor].CGColor;
        if ([commentView.content.text isEqualToString:@"  说点什么吧"]) {
            commentView.content.text = @"";
        }
        
    }];

}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            commentView.frame = CGRectMake(0, self.table.bottom, kScreenWidth, 50);
            commentView.cancleH.constant = 0;
            commentView.cancleBtn.alpha = 0;
            commentView.sureBtn.alpha = 0;
            commentView.content.layer.borderColor  =[UIColor lightGrayColor].CGColor;
//            if (commentView.content.text.length == 0) {
//                
//                commentView.content.text = @"  说点什么吧";
//            }
            commentView.ratingView.alpha = 0;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            
        }];
        
    } completion:^(BOOL finished) {
        

    }];
}


#pragma mark UITableViewDelegate&&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        
        return self.commentData.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    switch (indexPath.section) {
        case 0:
            return 150;
            break;
            
        case 1:{
            
            NSDictionary *commentDic = self.commentData[indexPath.row];
            CGRect commentFrame = [[commentDic objectForKey:@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            
            return commentFrame.size.height + 65;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, cell.width-20, 150)];
            //大图
            NSString *urlStr = self.avObj[@"albums"];;
            if([urlStr rangeOfString:@"http"].location !=NSNotFound) {
                
                //通过url获取
                AVFile *file = [AVFile fileWithURL:urlStr];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    
                    if (!error) {
                        imageV.image = [UIImage imageWithData:data];
                    }
                } progressBlock:^(NSInteger percentDone) {
                    //下载的进度数据，percentDone 介于 0 和 100。
                }];
                
                //没有图
            }else if ([urlStr rangeOfString:@"xoxoxo"].location != NSNotFound) {
                
                imageV.image = [UIImage imageNamed:@"加价小图"];
                
            }else {
                //通过objectId获取
                [AVFile getFileWithObjectId:urlStr withBlock:^(AVFile * _Nullable file, NSError * _Nullable error) {
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        
                        if (!error) {
                            
                            imageV.image = [UIImage imageWithData:data];
                        }
                        
                    } progressBlock:^(NSInteger percentDone) {
                        //下载的进度数据，percentDone 介于 0 和 100。
                    }];
                }];
            }

            [cell.contentView addSubview:imageV];
            
            return cell;
        }
            
            break;
        case 1:{
            
            CommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
            NSDictionary *commentDic = self.commentData[indexPath.row];
            AVUser *author = commentDic[@"user"];
            //楼层
            cell.floorLabel.text = [NSString stringWithFormat:@"%ld楼",indexPath.row+1];
            
            AVQuery *query = [AVQuery queryWithClassName:author[@"className"]];
            [query getObjectInBackgroundWithId:author[@"objectId"] block:^(AVObject *object, NSError *error) {
                // object 就是 id 为 558e20cbe4b060308e3eb36c 的 Todo 对象实例
                
                NSLog(@"sfsdf = %@",object);
                //头像
                AVQuery *query = [AVQuery queryWithClassName:@"_File"];
                [query whereKey:@"objectId" equalTo:object[@"avatar"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (objects.count > 0) {
                        AVObject *obj = objects[0];
                        AVFile *file = [AVFile fileWithURL:obj[@"url"]];
                        
                        [file getThumbnail:YES width:40 height:40 withBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            
                           cell.avatar.image = image;
                        }];
                    }else {
                        cell.avatar.image = [UIImage imageNamed:@"small默认"];
                    }
                }];
                
                //昵称
                cell.nameLabel.text = object[@"username"];
                //等级
                cell.levelLabel.text = [NSString stringWithFormat:@"%d",(int)([object[@"experience"] integerValue]/EXPRI)];
            }];
            
            //时间
            cell.timeLabel.text = commentDic[@"time"];
            cell.contentLabel.text = commentDic[@"content"];
            return cell;
        }
            
            break;
            
        default:
            break;
    }
    return nil;
    
}

- (void)repeatCommentCount:(SuccessCommentCallBack)block {

    _successCommentCallBack = block;
}


@end
