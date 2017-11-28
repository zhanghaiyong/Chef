//
//  SetMsgTableViewController.h
//  dream
//
//  Created by zhy on 17/2/7.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNickNameTableViewController : UITableViewController
@property (nonatomic,strong)NSString *flag;
@property (nonatomic,copy)void(^refreshNickNameBlock)(NSString *text);

@end
