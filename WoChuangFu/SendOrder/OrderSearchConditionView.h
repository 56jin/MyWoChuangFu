//
//  OrderSearchConditionView.h
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleSelectView.h"

@protocol OrderSeachConditionDelegate;
@interface OrderSearchConditionView : UIView<UIGestureRecognizerDelegate,SingleSelectViewDelegate,UITextFieldDelegate>
{
    id<OrderSeachConditionDelegate> delegate;
    OpenStatus selectOpenStatus;
    OrderType selectOrderType;
}
@property (nonatomic, assign)id<OrderSeachConditionDelegate> delegate;
@end

@protocol OrderSeachConditionDelegate <NSObject>
- (void)didOrderConditionSearch:(NSDictionary *)data;
@end



