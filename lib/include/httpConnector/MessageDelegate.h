//
//  MessageDelegate.h
//  libHttpConnector
//
//  Created by wuyoujian on 06/26/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageDelegate <NSObject>

@required

- (BOOL)isHouTai;//判断是不是后台登陆的 yes是后台，其余是no
- (NSString*)getBusinessCode;
- (NSString*)getRequest;
- (void)parseResponse:(NSString*)responseMessage;


@end
