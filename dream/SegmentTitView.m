//
//  SegmentView.m
//  FootMatch
//
//  Created by zhy on 2017/9/30.
//  Copyright © 2017年 zhy. All rights reserved.
//
#define scrollLineH 1.5
#import "SegmentTitView.h"

@implementation SegmentTitView
{
    NSArray *titles;
    UIScrollView *scrollView;
    NSArray *normalColorArr;
    NSArray *selectColorArr;
    UIView *scrollLine;
    NSMutableArray *labelsArray;
    NSInteger currentIndex;
}

//自定义初始化函数
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)ts
{
    self = [super initWithFrame:frame];
    if (self) {
        labelsArray = [NSMutableArray array];
        titles = [NSArray arrayWithArray:ts];
        normalColorArr = [NSArray arrayWithObjects:@"85",@"85",@"85", nil];
        selectColorArr = [NSArray arrayWithObjects:@"255",@"128",@"0", nil];
        [self setUp];
    }
    return self;
}

//UI界面
- (void)setUp {

    scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = NO;
    scrollView.bounces = NO;
    
    //添加lanbel
    for (int  i = 0; i<titles.count; i++) {
        
        CGFloat labelW = self.width / titles.count;
        CGFloat labelH = self.height - scrollLineH;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelW, 0, labelW, labelH)];
        label.text = titles[i];
        label.tag = i;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB([normalColorArr[0] floatValue], [normalColorArr[1] floatValue], [normalColorArr[2] floatValue]);
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        [labelsArray addObject:label];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
        [label addGestureRecognizer:tap];
    }
    
    //底部滑块
    UILabel *firstLab = labelsArray.firstObject;
    //第一个label字体颜色为橘色
    firstLab.textColor = RGB([selectColorArr[0] floatValue], [selectColorArr[1] floatValue], [selectColorArr[2] floatValue]);
    scrollLine = [[UIView alloc]initWithFrame:CGRectMake(firstLab.origin.x, self.height-scrollLineH, firstLab.width, scrollLineH)];
    scrollLine.backgroundColor = RGB([selectColorArr[0] floatValue], [selectColorArr[1] floatValue], [selectColorArr[2] floatValue]);
    [scrollView addSubview:scrollLine];
    [self addSubview:scrollView];
}

#pragma mark LabelTap
- (void)labelTap:(UITapGestureRecognizer *)gesture {
    
    //1.获取当前label的下标值
    UILabel *currentLab = (UILabel *)gesture.view;
    //2.获取之前的label
    UILabel *oldLab = labelsArray[currentIndex];
    
    //3.切换文字颜色
    currentLab.textColor = RGB([selectColorArr[0] floatValue], [selectColorArr[1] floatValue], [selectColorArr[2] floatValue]);
    oldLab.textColor = RGB([normalColorArr[0] floatValue], [normalColorArr[1] floatValue], [normalColorArr[2] floatValue]);
    
    //4.保存执行的下标值
    currentIndex = currentLab.tag;
    
    if (_tapLabBack) {
        _tapLabBack(currentLab.tag);
    }
    
    //5.滚动条发生变化
    CGFloat scrollLineX = currentLab.tag * scrollLine.width;
    [UIView animateWithDuration:0.15 animations:^{
        
        scrollLine.frame = CGRectMake(scrollLineX, scrollLine.frame.origin.y, scrollLine.width, scrollLine.height);
        
    }];
}

@end
