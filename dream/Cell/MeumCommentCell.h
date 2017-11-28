//
//  MeumCommentCell.h
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThreeBtnBlock)(NSInteger tags);

@interface MeumCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;

@property (nonatomic,copy)ThreeBtnBlock threeBtnBlock;

- (void)tapWitchBtnBlock:(ThreeBtnBlock)block;

@end
