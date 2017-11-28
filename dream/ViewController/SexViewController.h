//
//  SexViewController.h
//  dream
//
//  Created by zhy on 17/2/9.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "BaseViewController.h"

@interface SexViewController : BaseViewController
@property (nonatomic,copy)void(^refreshNickNameBlock)(NSString *text);
@end
