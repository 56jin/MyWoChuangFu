#import <UIKit/UIKit.h>

//商品评价导航条
@class TabBar;

@protocol TabBarDelegate <NSObject>

@optional
- (void)tabBar:(TabBar *)tabBar itemDidSelectedWithIndex:(NSInteger)index;

@end

@interface TabBar : UIView

@property(nonatomic,retain) id <TabBarDelegate> delegate;          //代理
@property(nonatomic,assign) NSInteger           currentItemIndex;  //当前选中下标
@property(nonatomic,strong) NSArray             *itemTitles;       //标题
@property(nonatomic,strong) UIColor             *lineColor;       //下划线颜色

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

@end
