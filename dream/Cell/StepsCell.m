//
//  StepsCell.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "StepsCell.h"

@implementation StepsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    [self.meumImg addGestureRecognizer:tap];
}

- (void)tapImage {
    
    self.stepCellBlock(self.meumImg.image);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)returnBigImageBlock:(StepCellBlock)block {

    _stepCellBlock = block;
}

@end
