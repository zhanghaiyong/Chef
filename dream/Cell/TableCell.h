//
//  TableCell.h
//  dream
//
//  Created by 张海勇 on 2017/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"


@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DYRateView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *meumImg;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *good;
@property (weak, nonatomic) IBOutlet UIButton *bad;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commenLeading;


@end
