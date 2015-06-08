//
//  IDCardInfo.h
//  RWSimCard
//
//  Created by BlueElf on 15/4/8.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCardInfo : NSObject

@property(strong, nonatomic) NSString* Name;
@property(strong, nonatomic) NSString* Sex;
@property(strong, nonatomic) NSString* SexCode;
@property(strong, nonatomic) NSString* Year;
@property(strong, nonatomic) NSString* Mon;
@property(strong, nonatomic) NSString* Day;
@property(strong, nonatomic) NSString* Address;
@property(strong, nonatomic) NSString* Issuedat;
@property(strong, nonatomic) NSString* CardNo;
@property(strong, nonatomic) NSString* Expireddate;
@property(strong, nonatomic) NSString* Effecteddate;
@property(strong, nonatomic) NSString* Nation;
@property(strong, nonatomic) NSString* NationCode;
@property(strong,nonatomic) NSData* Picture;

@end
