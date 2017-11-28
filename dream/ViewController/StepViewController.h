//
//  StepViewController.h
//  dream
//
//  Created by 张海勇 on 2017/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RenewCountBlock)(NSInteger count,NSString *type);

@interface StepViewController : BaseViewController
@property (nonatomic,strong)AVObject *avObj;

@property (nonatomic,copy)RenewCountBlock renewCountBlock;

- (void)repeatCountBlock:(RenewCountBlock)block;
@end
