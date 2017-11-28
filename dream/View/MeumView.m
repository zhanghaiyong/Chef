//
//  MeumView.m
//  dream
//
//  Created by zhy on 17/1/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "MeumView.h"
#import "MeumCell.h"
@interface MeumView ()
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSArray *typeArray;
@property (nonatomic,strong)NSArray *imageArray;
@end

@implementation MeumView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.image = [UIImage imageNamed:@"bgImg"];
        [self addSubview:bgImgView];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, bgImgView.width, bgImgView.height);
        [bgImgView addSubview:effectView];

        
        self.typeArray = [NSArray arrayWithObjects:@"家常菜",@"创意菜",@"素菜",@"凉菜",@"烘培",@"面食",@"汤",@"自制调味", nil];
        self.imageArray = [NSArray arrayWithObjects:@"家常菜",@"创意菜",@"素菜",@"凉菜",@"烘培",@"面食",@"汤",@"自制调味", nil];
        [self initSubVews];
    }
    return self;
}

- (void)initSubVews {

    self.table = [[UITableView alloc]initWithFrame:self.bounds];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.separatorInset = UIEdgeInsetsMake(0, -80, 0, -80);
    [self addSubview:self.table];
    

}

#pragma mark UITableViewDelegate&&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.height/self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    MeumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeumCell" owner:self options:nil] lastObject];
    }
    
    cell.meumImg.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.meumLabel.text = self.typeArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *className;
    
    switch (indexPath.row) {
        case 0:
            className = jiachangcai;
            break;
        case 1:
            className = chuangyicai;
            break;
        case 2:
            className = sucai;
            break;
        case 3:
            className = liangcai;
            break;
        case 4:
            className = hongpei;
            break;
        case 5:
            className = mianshi;
            break;
        case 6:
            className = tang;
            break;
        case 7:
            className = tiaowei;
            break;
            
        default:
            break;
    }
    
    
    self.tapMeumBlock(self.typeArray[indexPath.row],className);
}

- (void)returnTapedMeum:(TapMeumBlock)block {

    _tapMeumBlock = block;
}


@end
