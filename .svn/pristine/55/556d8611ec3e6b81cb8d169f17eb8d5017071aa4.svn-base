//
//  BubbleView.m
//  
//
//  Created by Wu YouJian on 9/6/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import "BubbleView.h"


@implementation BubbleView
@synthesize bubbleImageView;
@synthesize bubbleText;


-(id)initWithFrame:(CGRect)frame image:(NSString*)imageName
{
	if (self = [super init]) 
	{
		self.frame = CGRectZero;
		self.alpha = 0;
		self.backgroundColor = [UIColor clearColor];
		
		UIImage *bubble = [UIImage imageNamed:imageName];
		bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
		bubbleImageView.frame = CGRectZero;
		
		UIFont *font = [UIFont systemFontOfSize:13];
		bubbleText = [[UILabel alloc] initWithFrame:CGRectZero];
		bubbleText.backgroundColor = [UIColor clearColor];
		bubbleText.font = font;
		bubbleText.numberOfLines = 0;
		bubbleText.lineBreakMode = UILineBreakModeWordWrap;
		bubbleText.text = nil;
		
		[self addSubview:bubbleImageView];
		[self addSubview:bubbleText];		
	}
	return self;
}


-(void)viewMinifyAnimation
{
	if (self.alpha > 0) 
	{
		self.alpha -= 0.2;
		[NSTimer scheduledTimerWithTimeInterval:0.1f 
										 target:self 
									   selector:@selector(performDismiss)
									   userInfo:nil
										repeats:NO];
	}
}

-(void)performDismiss
{
	[self viewMinifyAnimation];	
}

-(void)ShowBubble:(CGPoint)point msg:(NSString*)msg
{
	UIFont *font = [UIFont systemFontOfSize:13];
	CGSize size = [msg sizeWithFont:font constrainedToSize:CGSizeMake(240.0f, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	bubbleText.frame = CGRectMake(21.0f, 14.0f, size.width+10, size.height+10);
	bubbleText.text = msg;
	bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height);
	self.frame = CGRectMake(point.x, point.y-bubbleText.frame.size.height-14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height);
	
	self.alpha = 1.0;
	[NSTimer scheduledTimerWithTimeInterval:2.0f 
									 target:self 
								   selector:@selector(performDismiss)
								   userInfo:nil
									repeats:NO];
}


-(void)dealloc {
	[bubbleImageView release];
	[bubbleText release];
    [super dealloc];
}


@end
