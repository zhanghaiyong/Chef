//
//  CommentView.m
//  dream
//
//  Created by zhy on 17/1/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "CommentsView.h"

@implementation CommentsView
{

    NSString *star;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    star = @"5";
    self.ratingView.fullStarImage = [UIImage imageNamed:@"StarFullLarge.png"];
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"StarEmptyLarge.png"];
    self.ratingView.editable = YES;
    self.ratingView.delegate = self;
}

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {

    star = [rate stringValue];
}

- (IBAction)cancleAction:(id)sender {
    
    [self.content resignFirstResponder];
    
}

- (IBAction)sureAction:(id)sender {
    
    if (self.content.text.length > 0) {
        
        AVUser *user = [AVUser currentUser];
        NSDictionary *newComment = @{@"user":user,@"time":[[NSDate date] toYMD2String],@"content":self.content.text};
        
        self.releaseCommentBlock(star,newComment);
            
        
        [self.content resignFirstResponder];
    }
    
}

- (void)releseCommentCallback:(ReleaseCommentBlock)block {

    _releaseCommentBlock = block;
}


@end
