//
//  FillLabelView.m
//  Sample
//
//  Created by sunleepy on 12-10-19.
//  Copyright (c) 2012年 sunleepy. All rights reserved.
//

#import "FillLabelView.h"
#import "FillLabel.h"

@implementation FillLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)setPadd:(NSInteger)padd {

    _padd = padd;
}

-(void)setSizeFont:(UIFont *)sizeFont {

    _sizeFont = sizeFont;
}

- (CGFloat)bindTags:(NSMutableArray*)tags {
    
    CGFloat frameWidth = self.frame.size.width;
    
    CGFloat tagsTotalWidth = 0.0f;
    CGFloat tagsTotalHeight = 0.0f;
    
    CGFloat tagHeight = 0.0f;
    int count = 0;
    for (NSString *tag in tags)
    {
        
        if (count >= 12) {
            break;
        }
        FillLabel *fillLabel = [[FillLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
        fillLabel.sizeFont = self.sizeFont;
        fillLabel.padd = self.padd;
        fillLabel.moreColor = self.moreColor;
        fillLabel.text = tag;
        tagsTotalWidth += fillLabel.frame.size.width + self.padd;
        tagHeight = fillLabel.frame.size.height;
        
        if(tagsTotalWidth >= frameWidth)
        {
            tagsTotalHeight += fillLabel.frame.size.height + self.padd;
            tagsTotalWidth = 0.0f;
            fillLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, fillLabel.frame.size.width, fillLabel.frame.size.height);
            tagsTotalWidth += fillLabel.frame.size.width + self.padd;
        }
        [self addSubview:fillLabel];
        count++;

    }
    
    tagsTotalHeight += tagHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagsTotalHeight);
    
    NSLog(@"xoxoxo = %f",tagsTotalHeight);
    
    return tagsTotalHeight;
}

@end
