//
//  UITCLabel.m
//  Grid_Test
//
//  Created by Ma Genius on 10-10-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UITCLabel.h"


@implementation UITCLabel
@synthesize nLineNum,nColumnNum,isLinked,strHref,isSelected;
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	timeStampTouchBegin = event.timestamp;
	
	//	UITouch *t = [touches anyObject];
	//	if([t tapCount] == 1){
	//		[mytarget performSelector:myaction1 withObject:self];
	//		
	//	}
	
	[super touchesBegan:touches withEvent:event];
}

#ifndef __DURATION_SHORT_PRESS_
#define __DURATION_SHORT_PRESS_ 0.2f
#endif // __DURATION_LONG_PRESS_

#ifndef __DURATION_LONG_PRESS_
#define __DURATION_LONG_PRESS_ 0.5f
#endif // __DURATION_LONG_PRESS_


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	
	if (__DURATION_SHORT_PRESS_ + timeStampTouchBegin > timeStampTouchBegin &&
		__DURATION_LONG_PRESS_ + timeStampTouchBegin > event.timestamp) {
		[mytarget performSelector:myaction1 withObject:self];
	}
	
	if (__DURATION_LONG_PRESS_ + timeStampTouchBegin <= event.timestamp) {
		
		[mytarget performSelector:myaction2 withObject:self];
	}
	
	
	[super touchesEnded:touches withEvent:event];
}


-(void) LineNum:(int)aLineNum 
	  ColumnNum:(int)aColumnNum 
		 target:(id)aTarget 
		action1:(SEL) aAction1
		action2:(SEL) aAction2
{
	nLineNum = aLineNum;
	nColumnNum = aColumnNum;
	mytarget = aTarget;
	myaction1 = aAction1;
	myaction2 = aAction2;
}





- (void)dealloc
{
	[super dealloc];
}

@end
