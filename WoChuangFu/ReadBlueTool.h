//
//  ReadBlueTool.h
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/7/7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^GetIDcardMessageBlock)(NSDictionary *dic);
typedef void (^ResutlOrSearchBlock)(NSMutableArray *searchResultArr);
typedef void (^ConnectToBlueToolsBlock)(BOOL isConnected);
typedef void (^MessageBlock)(NSDictionary *dic);
@interface ReadBlueTool : NSObject


-(void)searchBlueTool:(ResutlOrSearchBlock)searchResultBlock;
-(void)connectToBlueTool:(ConnectToBlueToolsBlock)connectResultBlock index:(int)index;
-(void)getMessage:(MessageBlock)messageBlock;


@property(nonatomic,copy) GetIDcardMessageBlock iDcardMessageBlock;
@property(nonatomic,copy) ResutlOrSearchBlock resutlOrSearchBlock;
@property(nonatomic,copy) ConnectToBlueToolsBlock connectToBlueToolsBlock;
@end
