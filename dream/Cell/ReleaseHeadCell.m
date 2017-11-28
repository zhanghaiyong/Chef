//
//  ReleaseHeadCell.m
//  dream
//
//  Created by zhy on 17/1/23.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "ReleaseHeadCell.h"
#import "FillLabel.h"

@implementation ReleaseHeadCell
{

    CGFloat zhuTotalWidth;
    CGFloat zhuTotalHeight;
    
    CGFloat fuTotalWidth;
    CGFloat fuTotalHeight;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    zhuTotalWidth = 35.0f;
    zhuTotalHeight = 50.0f;
    
    fuTotalWidth = 35.0f;
    fuTotalHeight = 50.0f;
    self.stepContent.delegate = self;
    self.contentTV.delegate = self;
    self.meumNameTF.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    [self.setpImg addGestureRecognizer:tap];
    [self.meumImg addGestureRecognizer:tap];
    
    [self.meumNameTF setValue:@10 forKey:@"paddingLeft"];
}

- (void)tapImage {

    self.takePhotoBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)choseMeumTypeAction:(id)sender {

    self.setCellHeightBlock(@"");
}

- (IBAction)addStepAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        self.add_reduceStepBlock(@"reduce");
        button.selected = NO;
    }else {
    
        self.add_reduceStepBlock(@"add");
        button.selected = YES;
    }
}

- (IBAction)addLabelAction:(id)sender {
    
    NSString *alertStr;
    if (self.tag == 200) {
        alertStr = @"添加主材";
    }else {
    
        alertStr = @"添加辅材";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertStr message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.delegate = self;
    [alert show];
    
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        
        if (txt.text.length > 0) {
            
            
            if (self.tag == 200) {
                
                self.setCellHeightBlock(txt.text);
                
            }else {

                self.setCellHeightBlock(txt.text);
            }
        }
    }
}

- (void)returnHeight:(SetCellHeightBlock)block {

    _setCellHeightBlock = block;
}

- (void)addSetpBack:(Add_reduceStepBlock)block {

    _add_reduceStepBlock = block;
}

- (void)setStepContentBack:(StepContentBlock)block {

    _stepContentBlock = block;
}

- (void)takePhotoBack:(TakePhotoBlock)block {

    _takePhotoBlock = block;
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {

    if (textView.text.length > 0) {
        
        self.stepContentBlock(textView.text);
    }else {
    
        if (textView == self.contentTV) {
            
            self.contentTV.text = @"说点什么吧";
        }else {
        
            self.stepContent.text = @"步骤内容";
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    self.contentTV.text = @"";
    self.stepContent.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField.text.length > 0) {
        
        self.stepContentBlock(textField.text);
    }
}


@end
