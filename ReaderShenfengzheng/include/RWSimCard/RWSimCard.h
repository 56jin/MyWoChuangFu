//
//  RWSimCard.h
//  RWSimCard
//
//  Created by BlueElf on 14/11/19.
//  Copyright (c) 2014年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderDelegate.h"
#import "IDCardInfo.h"

@interface RWSimCard : NSObject

-(NSString *)insertCard:(NSString *)option iccid:(NSString *)iccid imsi:(NSString *)imsi number:(NSString *)custNum;

-(NSString *)readCardNo:(BOOL)is3GCard;

-(int)getReaderPower;

-(IDCardInfo *)getIDCard;

-(NSString *)queryImsi:(BOOL)is3GCard;

-(NSString *)queryUsimNo;

-(void)setReaderDelegate:(id<ReaderDelegate>)obj;

@end
