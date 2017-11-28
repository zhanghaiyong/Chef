//
//  BaseParams.h
//  dream
//
//  Created by zhy on 17/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseParams : NSObject

//应用APPKEY(应用详细页查询)
@property (nonatomic,strong)NSString *key;
//返回数据的格式,xml或json，默认json
@property (nonatomic,strong)NSString *dtype;
//数据返回条数，最大30，默认10
@property (nonatomic,strong)NSString *rn;
@end
