//
//  MeumView.h
//  dream
//
//  Created by zhy on 17/1/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

typedef void(^TapMeumBlock)(NSString *title,NSString *className);

#import <UIKit/UIKit.h>

@interface MeumView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)TapMeumBlock tapMeumBlock;

- (void)returnTapedMeum:(TapMeumBlock)block;

@end
