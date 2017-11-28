//
//  StepsCell.h
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StepCellBlock)(UIImage *img);

@interface StepsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meumImg;
@property (weak, nonatomic) IBOutlet UILabel *stepIntroLabel;

@property (nonatomic,copy)StepCellBlock stepCellBlock;

- (void)returnBigImageBlock:(StepCellBlock)block;

@end
