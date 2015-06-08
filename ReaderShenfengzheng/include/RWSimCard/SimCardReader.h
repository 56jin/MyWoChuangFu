//
//  SimCardReader.h
//  RWSimCard
//
//  Created by BlueElf on 15/5/4.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderDelegate.h"

@interface SimCardReader : NSObject

-(NSString *)insertCard:(NSString *)option iccid:(NSString *)iccid imsi:(NSString *)imsi number:(NSString *)custNum;

-(NSString *)readCardNo:(BOOL)is3GCard;

-(NSString *)queryImsi:(BOOL)is3GCard;

-(NSString *)queryUsimNo;

-(void)setReaderDelegate:(id<ReaderDelegate>)obj;

@end
