//
//  MyTimer.m
//  FJBI
//
//  Created by asiainfo-linkage on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTimer.h"

@interface MyTimer(Private)

-(void)Run:(NSTimer*)timer;

-(void)Run2:(NSTimer *)timer;

@end

@implementation MyTimer
@synthesize iTimer;
@synthesize iSeconds;
@synthesize iRefeshTime;


-(id)init
{
	if (self = [super init]) {
		self.iRefeshTime = REFRESH_TIME_DEF;
	}
	
	return self;
}

-(void)dealloc
{
	[iTimer release];
	[super dealloc];
}

-(void)setSecondTarget:(id)aTarget actionSecondRun:(SEL)aAction
{
	targetSecond = aTarget;
	actionSecond = aAction;
}

-(void)StartSecondTimer
{
	if (iTimer != nil) 
		[iTimer invalidate];
	iTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
											  target:self
											selector:@selector(Run:)
											userInfo:nil
											 repeats:YES];
}

-(void)Run:(NSTimer*)timer
{
	iSeconds++;
	BOOL isFinish = iSeconds >= iRefeshTime ? YES : NO;
	if (targetSecond && actionSecond && isFinish) {
		iSeconds = 0;
		[targetSecond performSelector:actionSecond withObject:self];
	}
}

-(void)ResetSecondTimer
{
	iSeconds = 0;
	[self StartSecondTimer];
}

-(void)ContinueSecondTimer
{
	[self StartSecondTimer];
}

-(void)StopSecondTimer
{
	if (iTimer != nil) {
		[iTimer invalidate];
		iTimer = nil;
	}
}

-(void)setTarget:(id)aTarget actionRun:(SEL)aAction
{
	target       = aTarget;
	action       = aAction;
}

-(void)StartTimer:(NSTimeInterval)ti
{
	if (iMyTimer != nil) 
		[iMyTimer invalidate];
	iMyTimer = [NSTimer scheduledTimerWithTimeInterval:ti
												target:self
											  selector:@selector(Run2:)
											  userInfo:nil
											   repeats:YES];
}

-(void)Run2:(NSTimer *)timer
{
	if (target && action) {
		[target performSelector:action withObject:self];
	}
}

-(void)StopTimer
{
	if (iMyTimer != nil) 
	{
		[iMyTimer invalidate];
		iMyTimer = nil;
	}
}

@end
