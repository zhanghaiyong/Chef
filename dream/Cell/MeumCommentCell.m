//
//  MeumCommentCell.m
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "MeumCommentCell.h"

@implementation MeumCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    UIButton *changgeBtn = [[UIButton alloc]initWithFrame:button.frame];
    [changgeBtn setImage:button.currentImage forState:UIControlStateNormal];
    [changgeBtn setTitle:button.currentTitle forState:UIControlStateNormal];
    [self.contentView addSubview:changgeBtn];
    
    CGFloat kAnimationDuration = 0.5f;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0];
    showViewAnn.duration = kAnimationDuration;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kAnimationDuration;
    group.removedOnCompletion = NO;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
//    group.delegate = self;
    [group setAnimations:@[scaleAnimation,showViewAnn]];
    
    [changgeBtn.layer addAnimation:group forKey:@"animationOpacity"];
    
    self.threeBtnBlock(button.tag);
    
}

- (void)tapWitchBtnBlock:(ThreeBtnBlock)block {

    _threeBtnBlock = block;
}

@end
