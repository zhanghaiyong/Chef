//
//  CommentView.h
//  dream
//
//  Created by zhy on 17/1/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

typedef void(^ReleaseCommentBlock)(NSString *s,NSDictionary *commentDic);

@interface CommentsView : UIView<DYRateViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet DYRateView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancleH;

@property (nonatomic,copy)ReleaseCommentBlock releaseCommentBlock;

- (void)releseCommentCallback:(ReleaseCommentBlock)block;

@end
