//
//  MyTimer.h
//  FJBI
//
//  Created by asiainfo-linkage on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define	REFRESH_TIME_DEF				10.0

@interface MyTimer : NSObject {
	id targetSecond;
	SEL actionSecond;
	
	id target;
	SEL action;
	
	NSTimer* iTimer;
	NSTimer* iMyTimer;
	NSTimeInterval iSeconds;
    
    NSTimeInterval iRefeshTime;
}

@property(nonatomic, retain)NSTimer* iTimer;
@property(nonatomic, assign)NSTimeInterval iSeconds;
@property(nonatomic, assign)NSTimeInterval iRefeshTime;

//一秒脉冲定时器
-(void)setSecondTarget:(id)aTarget actionSecondRun:(SEL)aAction;
-(void)StartSecondTimer;
-(void)ResetSecondTimer;
-(void)ContinueSecondTimer;
-(void)StopSecondTimer;

//定时器
-(void)setTarget:(id)aTarget actionRun:(SEL)aAction;
-(void)StartTimer:(NSTimeInterval)ti;
-(void)StopTimer;

@end
