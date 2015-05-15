//
//  TimeTreatment.m
//  FJPZGZ
//
//  Created by Ma Genius on 10-11-4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimeTreatment.h"


@implementation TimeTreatment


+(void)startTime:(NSString*)aName
{
	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	[[NSUserDefaults standardUserDefaults]setDouble:currentTime forKey:aName];
	BOOL isOK = [[NSUserDefaults standardUserDefaults] synchronize];
		
	if (!isOK) {
		//[ModalAlert say:[NSString stringWithFormat:@"%@###startTime ERR",aName]];
	}
}


+(void)endTime:(NSString*)aName
{
	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	[[NSUserDefaults standardUserDefaults]setDouble:currentTime forKey:[NSString stringWithFormat:@"%@_end",aName]];
	
	BOOL isOK = [[NSUserDefaults standardUserDefaults] synchronize];
	
	if (!isOK) {
		//[ModalAlert say:[NSString stringWithFormat:@"%@###endTime ERR",aName]];
	}
	
}

+(double)timeInterval:(NSString*)aName
{
	double startTime = [[NSUserDefaults standardUserDefaults]doubleForKey:aName];
	double endTime = [[NSUserDefaults standardUserDefaults]doubleForKey:[NSString stringWithFormat:@"%@_end",aName]];

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:aName];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_end",aName]];

	
	
	BOOL isOK = [[NSUserDefaults standardUserDefaults] synchronize];
	
	if (!isOK) {
		//[ModalAlert say:[NSString stringWithFormat:@"%@###timeInterval ERR",aName]];
	}
	
	return endTime-startTime;
}


@end
