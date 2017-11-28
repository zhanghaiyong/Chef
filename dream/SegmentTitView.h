//
//  SegmentView.h
//  FootMatch
//
//  Created by zhy on 2017/9/30.
//  Copyright © 2017年 zhy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentTitView : UIView
@property (nonatomic,strong)void (^tapLabBack)(NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)ts;
@end
