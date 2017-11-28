//
//  StepHeadCell.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "StepHeadCell.h"

@implementation StepHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ratingView.rate = 3.2;
    self.ratingView.fullStarImage = [UIImage imageNamed:@"StarFullLarge.png"];
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"StarEmptyLarge.png"];
    self.ratingView.editable = NO;
    
    self.fillView.sizeFont = [UIFont boldSystemFontOfSize:10];
    self.fillView.padd = 6;
    self.fillView.moreColor = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
