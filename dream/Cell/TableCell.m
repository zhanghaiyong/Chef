//
//  TableCell.m
//  dream
//
//  Created by 张海勇 on 2017/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.ratingView.rate = 3.2;
    self.ratingView.fullStarImage = [UIImage imageNamed:@"StarFullLarge.png"];
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"StarEmptyLarge.png"];
    self.ratingView.editable = NO;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
