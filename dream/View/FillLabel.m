//
//  FillLabel.m
//  Sample
//
//  Created by sunleepy on 12-10-19.
//  Copyright (c) 2012年 sunleepy. All rights reserved.
//

#import "FillLabel.h"

#define MAX_SIZE_HEIGHT 10000
#define DEFAULT_BACKGROUDCOLOR [UIColor colorWithRed:47.0/255 green:157.0/255 blue:216.0/255 alpha:1]
#define DEFAULT_TEXTCOLOR [UIColor whiteColor]
//#define DEFAULT_FONT [UIFont boldSystemFontOfSize:15]
#define DEFAULT_TEXTALIGNMENT UITextAlignmentCenter
#define DEFAULT_RADIUS 3.0f

@implementation FillLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.textColor = DEFAULT_TEXTCOLOR;
//        self.font = DEFAULT_FONT;
        self.textAlignment = NSTextAlignmentCenter;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = DEFAULT_RADIUS;

    }
    return self;
}

- (void)setSizeFont:(UIFont *)sizeFont {

    _sizeFont = sizeFont;
    self.font = sizeFont;
    
}

-(void)setMoreColor:(BOOL)moreColor {

    _moreColor = moreColor;
    
    if (!self.moreColor) {
        self.backgroundColor = DEFAULT_BACKGROUDCOLOR;
    }else {
    
        int R = (arc4random() % 256) ;
        int G = (arc4random() % 256) ;
        int B = (arc4random() % 256) ;
        self.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    }
    
}

-(void)setPadd:(NSInteger)padd {
    
    _padd = padd;
}

-(void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}

-(void)setText:(NSString *)text
{
    super.text = text;
    
    CGRect textFrame = [self.text boundingRectWithSize:CGSizeMake(kScreenWidth, MAX_SIZE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.sizeFont} context:nil];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, textFrame.size.width + 6, textFrame.size.height+self.padd);
}

@end
