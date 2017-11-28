//
//  StepHeadCell.h
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
#import "FillLabelView.h"
@interface StepHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *meumImg;
@property (weak, nonatomic) IBOutlet DYRateView *ratingView;
@property (weak, nonatomic) IBOutlet FillLabelView *fillView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
