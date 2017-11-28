//
//  MeumModel.h
//  dream
//
//  Created by zhy on 17/1/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepModel.h"

@interface MeumModel : NSObject<MJKeyValue>
//名称
@property (nonatomic,strong)NSString *title;
//标签
@property (nonatomic,strong)NSString *tags;
//说明
@property (nonatomic,strong)NSString *imtro;
//主料
@property (nonatomic,strong)NSString *ingredients;
//佐料
@property (nonatomic,strong)NSString *burden;
//成品图片
@property (nonatomic,strong)NSArray *albums;
//步骤
@property (nonatomic,strong)NSArray  *steps;


@end
