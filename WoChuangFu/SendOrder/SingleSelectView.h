//
//  SingleSelectView.h
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum OpenStatus{
    All,
    noOpen,
    isOpen
} OpenStatus;

typedef enum OrderType
{
    chuangFuOrder,
    phoneSaleOrder,
    FocusOrder,
    chuangFuOrder2
} OrderType;

@protocol SingleSelectViewDelegate;
@interface SingleSelectView : UIView
{
    OpenStatus openStatus;
    OrderType orderType;
    BOOL isOrderType;
    id<SingleSelectViewDelegate> delegate;
}
@property (nonatomic ,assign)OpenStatus openStatus;
@property (nonatomic ,assign)OrderType orderType;
@property (nonatomic ,assign)BOOL isOrderType;
@property (nonatomic ,assign)id<SingleSelectViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withOrderType:(BOOL)isorderType;
@end


@protocol SingleSelectViewDelegate <NSObject>
- (void)singleSelectViewdidSelectValue:(SingleSelectView *)singleView;
@end
