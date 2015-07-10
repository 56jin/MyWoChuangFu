//
//  IDCardReader.h
//  RWSimCard
//
//  Created by BlueElf on 15/5/4.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCardInfo.h"
#import "ReaderDelegate.h"

@interface IDCardReader : NSObject

-(IDCardInfo *)getIDCard:(NSString *)paramsJson;

-(void)setReaderDelegate:(id<ReaderDelegate>)obj;

@end
