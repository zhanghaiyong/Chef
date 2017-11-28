//
//  AssistCell.h
//  dream
//
//  Created by 张海勇 on 2017/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FillLabelView.h"
@interface AssistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FillLabelView *fillView;

- (void)setFillBindTags:(NSMutableArray *)tags;

@end
