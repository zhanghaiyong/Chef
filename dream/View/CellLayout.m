
#import "CellLayout.h"

@implementation CellLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        self.itemSize = CGSizeMake((kScreenWidth-30)/2, (kScreenWidth-30)/2*1.2);//每个item的大小，可使用代理对每个item不同设置
        self.minimumLineSpacing = 10;        //每行的间距
        self.minimumInteritemSpacing = 5;    //每行内部item cell间距
//        self.footerReferenceSize=CGSizeMake(0, 30);
//        self.headerReferenceSize=CGSizeMake(SCREEN_W, CONTROL_H*[Uitils returnScreenScale]);//页眉和页脚大小
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//item cell内部四周的边界（top，left，bottom，right）
    
        
    }
    return self;
}

/*返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize {

}
 */

/*
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    //返回rect中所有的元素的布局属性
    //返回的是包含UICollectionViewLayoutAttributes的NSArray
 
     UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
     
     layoutAttributesForCellWithIndexPath:
     layoutAttributesForSupplementaryViewOfKind:withIndexPath:
     layoutAttributesForDecorationViewOfKind:withIndexPath:
 
}
*/

/*
 -(UICollectionViewLayoutAttributes _)layoutAttributesForItemAtIndexPath:(NSIndexPath _)indexPath
 
 返回对应于indexPath的位置的cell的布局属性
 */

/*
 -(UICollectionViewLayoutAttributes _)layoutAttributesForSupplementaryViewOfKind:(NSString _)kind atIndexPath:(NSIndexPath *)indexPath
 
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 */

/*
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString_)decorationViewKind atIndexPath:(NSIndexPath _)indexPath
 
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 */


/*
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
 */
@end
