//
//  ReleaseHeadCell.h
//  dream
//
//  Created by zhy on 17/1/23.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetCellHeightBlock)(NSString *content);

typedef void(^Add_reduceStepBlock)(NSString *type);

typedef void(^StepContentBlock)(NSString *content);

typedef void(^TakePhotoBlock)(void);

@interface ReleaseHeadCell : UITableViewCell<UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *starLabel;

#pragma mark cell1
@property (weak, nonatomic) IBOutlet UIImageView *meumImg;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UITextField *meumNameTF;

#pragma mark cell2
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

#pragma mark cell3
@property (weak, nonatomic) IBOutlet UILabel *cellName;

#pragma mark cell4
@property (weak, nonatomic) IBOutlet UIButton *add_reduceBtn;
@property (weak, nonatomic) IBOutlet UITextView *stepContent;
@property (weak, nonatomic) IBOutlet UIImageView *setpImg;
@property (weak, nonatomic) IBOutlet UILabel *setpNumLabel;

//计算高度
@property (nonatomic,copy)SetCellHeightBlock setCellHeightBlock;
- (void)returnHeight:(SetCellHeightBlock)block;

//添加步骤
@property (nonatomic,copy)Add_reduceStepBlock add_reduceStepBlock;
- (void)addSetpBack:(Add_reduceStepBlock)block;

//设置步骤内容
@property (nonatomic,copy)StepContentBlock stepContentBlock;
- (void)setStepContentBack:(StepContentBlock)block;

//点击拍照
@property (nonatomic,copy)TakePhotoBlock takePhotoBlock;
- (void)takePhotoBack:(TakePhotoBlock)block;
@end
