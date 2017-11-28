//
//  MeumParams.h
//  dream
//
//  Created by zhy on 17/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeumParams : BaseParams

//标签ID
@property (nonatomic,strong)NSString *cid;
//数据返回起始下标，默认0
@property (nonatomic,strong)NSString *pn;
//steps字段屏蔽，默认显示，format=1时屏蔽
@property (nonatomic,strong)NSString *format;
@end
