//
//  CommentViewController.h
//  dream
//
//  Created by zhy on 17/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessCommentCallBack)(NSInteger count);

@interface CommentViewController : UIViewController
@property (nonatomic,strong)AVObject *avObj;

@property (nonatomic,copy)SuccessCommentCallBack successCommentCallBack;

- (void)repeatCommentCount:(SuccessCommentCallBack)block;

@end
