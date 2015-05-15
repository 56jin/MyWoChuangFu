//
//  DataDictionary_back_cart_item.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-22.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDictionary_back_cart_item : NSObject

@property (nonatomic, retain) NSString *ITEM_CODE;
@property (nonatomic, retain) NSString *ITEM_NAME;
@property (nonatomic, retain) NSString *ITEM_URL;

- (id)initWithDataItem:(NSDictionary *)dic;

@end
