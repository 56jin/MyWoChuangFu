//
//  GifView.m
//  SaleToolsKit
//
//  Created by syerven on 12-3-15.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath{
    
    self = [super initWithFrame:frame];
    if (self) {
        
		gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
													 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
		gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
		count =CGImageSourceGetCount(gif);
		timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(play) userInfo:nil repeats:YES];
		[timer fire];
    }
    return self;
}

-(void)play
{
	index ++;
	index = index%count;
	CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
	self.layer.contents = (id)ref;
    if (ref != NULL) {
        CFRelease(ref);
    }
}
-(void)removeFromSuperview
{
	NSLog(@"removeFromSuperview");
	[timer invalidate];
	timer = nil;
	[super removeFromSuperview];
}
- (void)dealloc {
    NSLog(@"dealloc");
	CFRelease(gif);
	[gifProperties release];
    [super dealloc];
}

@end
