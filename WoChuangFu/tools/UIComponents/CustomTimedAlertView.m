//
//  CustomTimedAlertView.m
//  FJBI
//
//  Created by asiainfo-linkage on 10-12-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomTimedAlertView.h"


@implementation CustomTimedAlertView

-(id)initWithFrame:(CGRect)frame
		  imageName:(NSString*)name
		  labelText:(NSString*)text
{
	if (self = [super init]) 
	{
		iImageView = [[UIImageView alloc] initWithFrame:frame];
		iLabel = [[UILabel alloc] initWithFrame:frame];
		
		iImageView.image = [UIImage imageNamed:name];
		iImageView.alpha = 0;
		[iLabel setFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
		iLabel.text = text;
		iLabel.backgroundColor = [UIColor clearColor];
		iLabel.textAlignment = UITextAlignmentCenter;
		iLabel.numberOfLines = 2;
		iLabel.font = [UIFont systemFontOfSize:14];
		[iImageView addSubview:iLabel];
		
		[self addSubview:iImageView];
	}
	return self;
}

-(void)dealloc
{
	[iImageView release];
	[iLabel release];
	
	[super dealloc]; 
}

- (void)viewMinifyAnimation:(UIImageView*)aView
{
	if (aView.alpha > 0) 
	{
		aView.alpha -= 0.3;
		[NSTimer scheduledTimerWithTimeInterval:0.1f 
										 target:self 
									   selector:@selector(performDismiss)
									   userInfo:nil
										repeats:NO];
	}
}

- (void)performDismiss
{
	[self viewMinifyAnimation:iImageView];	
}

- (void)viewZoomAnimation:(UIImageView*)aView
{
	[UIView beginAnimations:nil context:nil];
	aView.transform = CGAffineTransformMakeScale (0.1, 0.1);
	[UIView setAnimationDuration:.5];
	aView.transform = CGAffineTransformMakeScale (1, 1);
	[UIView commitAnimations];
}

-(void)changeAlphaImageName:(NSString*)imageName labelText:(NSString*)labletext
{
	if (imageName != nil) 
		iImageView.image = [UIImage imageNamed:imageName];
	
	if (labletext != nil) {
		iLabel.text = labletext;
		iLabel.numberOfLines = 2;
		iLabel.font = [UIFont systemFontOfSize:14];
	}
	
	iImageView.alpha = 1;
	[NSTimer scheduledTimerWithTimeInterval:1.5f 
									 target:self 
								   selector:@selector(performDismiss)
								   userInfo:nil
									repeats:NO];
}


@end
