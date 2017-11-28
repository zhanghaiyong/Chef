//
//  MeumModel.m
//  dream
//
//  Created by zhy on 17/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "MeumModel.h"

@implementation MeumModel

//实现这个方法，就会自动吧数组中的字典转化成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"steps":[StepModel class]};
}

@end
