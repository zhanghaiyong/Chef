//
//  AssistCell.m
//  dream
//
//  Created by 张海勇 on 2017/1/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import "AssistCell.h"

@implementation AssistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFillBindTags:(NSMutableArray *)tags {
    
    [self.fillView bindTags:tags];
}

@end
