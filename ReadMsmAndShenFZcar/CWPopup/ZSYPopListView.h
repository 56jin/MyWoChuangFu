//
//  ZSYPopListView.h
//  StoreGuest
//
//  Created by 1 on 14-9-29.
//  Copyright (c) 2014年 mobitide. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"

@protocol ZSYPopListViewDelegate <NSObject>

-(void)sureDoneWith:(NSDictionary *)resion;

@end

@interface ZSYPopListView : UIView<ZSYPopoverListDatasource,ZSYPopoverListDelegate,UITextFieldDelegate>{
    
    NSMutableArray * dateData;  // 取消原因数据
    ZSYPopoverListView *listView;
    NSDictionary *state_info; //选择原因
}

@property BOOL isTitle;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic,assign) id<ZSYPopListViewDelegate> delegate;


- (void)dissViewClose;
- (id)initWitZSYPopFrame:(CGRect)frame WithNSArray:(NSMutableArray *)data;
- (id)initWitZSYPopFrame:(CGRect)frame WithNSArray:(NSMutableArray *)data WithString:(NSString *)string;

//    dateData = [NSMutableArray arrayWithObjects:@"抱歉，现在有点忙",@"对不起，你购买的商品暂时没有货了",@"东家有喜，歇业一天",@"其他", nil];
//    ZSYPopListView *zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, 280) WithNSArray:dateData];
//    zsy.delegate = self;


@end
