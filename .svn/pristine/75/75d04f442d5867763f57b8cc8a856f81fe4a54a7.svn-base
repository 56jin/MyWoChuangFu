//
//  UITCLabel.h
//  Grid_Test
//
//  Created by Ma Genius on 10-10-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITCLabel : UILabel {
	
	int nLineNum;
	int nColumnNum;
	NSString *strHref;
	BOOL isLinked;
	id mytarget;
	SEL myaction1;
	SEL myaction2;
    BOOL isSelected;
	
	
	float timeStampTouchBegin;
	float timeStampTouchEnd;
}
@property (assign) 	int nLineNum;
@property (assign) 	int nColumnNum;
@property (assign) 	BOOL isLinked;
@property (assign) NSString *strHref;
@property (assign)  BOOL isSelected;
-(void) LineNum:(int)aLineNum 
	  ColumnNum:(int)aColumnNum 
		 target:(id)aTarget 
		action1:(SEL) aAction1
		action2:(SEL) aAction2;



@end
