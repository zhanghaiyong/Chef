//
//  CollectionCell.h
//  dream
//
//  Created by 张海勇 on 2017/1/20.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meumImg;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;



@end
