//
//  SectionClickView.h
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionClickViewDelegate;

@interface SectionClickView : UIView<UIGestureRecognizerDelegate>
{
    id<SectionClickViewDelegate> delegate;
    BOOL isOpen;
}
@property (nonatomic ,assign) BOOL isOpen;
@property (nonatomic ,assign)id<SectionClickViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithOpen:(BOOL)open;
- (void)reloadSectionViewWithOrderID:(NSString *)orderID orderType:(NSString *)orderType arrowStatus:(BOOL)isShow;
@end

@protocol SectionClickViewDelegate <NSObject>
- (void)didSelectView:(SectionClickView *)sectionView isShow:(BOOL)isShow;
- (void)didClickedPhoto:(SectionClickView *)sectionView;
- (void)didShowCheckFlow:(SectionClickView *)sectionView;
@end
