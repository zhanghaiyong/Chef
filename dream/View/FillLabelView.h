//
//  FillLabelView.h
//  Sample
//
//  Created by sunleepy on 12-10-19.
//  Copyright (c) 2012年 sunleepy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillLabelView : UIView

- (CGFloat)bindTags:(NSMutableArray*)tags;

@property (nonatomic,strong)UIFont *sizeFont;
@property (nonatomic,assign)NSInteger padd;
@property (nonatomic,assign)BOOL moreColor;

@end
