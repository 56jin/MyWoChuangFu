//
//  MyScrollView.m
//  PhotoBrowserEx
//
//  Created by on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"


@implementation MyScrollView


@synthesize image;
@synthesize myScrollViewDelegate;

#pragma mark -
#pragma mark === Intilization ===
#pragma mark -
- (id)initWithFrameAndImg:(CGRect)frame withImage:(UIImage *)img
{
    if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		self.minimumZoomScale = 0.5;
		self.maximumZoomScale = 100;
		self.showsVerticalScrollIndicator = YES;
		self.showsHorizontalScrollIndicator = YES;
		//[self setContentMode:UIViewContentModeTopLeft];
        //self.contentSize = CGSizeMake(380, 480-44);
        float width=0.0f;
        float height=0.0f;
        float x = 0.0f;
        float y = 0.0f;
        float rate = 1.0f; 
        if (img.size.height != 0) {
            rate = img.size.width/img.size.height;
        }
        
        if (rate > frame.size.width/frame.size.height) {
            width = frame.size.width;
            height = (1.0f / rate)*width ;
            x = 0.0f;
            y = frame.size.height/2.0f - height/2.0f;
        } else {
            height = frame.size.height;
            width = rate * height ;
            x = frame.size.width/2.0f- width/2.0f;
            y = 0.0f;
        }
		imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        imageView.image = img;
		[self addSubview:imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)img
{
	imageView.image = img;
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{	
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	//
	
	//CGFloat zs = scrollView.zoomScale;
	//zs = MAX(zs, 1.0);
	//zs = MIN(zs, 2.0);	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = scrollView.zoomScale;	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	
	UITouch *touch = [touches anyObject];
      
    if([touch tapCount] == 1) {
        if (nil != self.myScrollViewDelegate && [self.myScrollViewDelegate respondsToSelector:@selector(clickPhoto:)]) {
            [self.myScrollViewDelegate clickPhoto:self];
        }

     } /*else if ([touch tapCount] == 2) {
         CGFloat zs = self.zoomScale;
         zs = (zs == 1.0) ? 2.0 : 1.0;
         
         [UIView beginAnimations:nil context:NULL];
         [UIView setAnimationDuration:0.3];			
         self.zoomScale = zs;	
         [UIView commitAnimations];
     }*/
    
}

#pragma mark -
#pragma mark === dealloc ===
#pragma mark -
- (void)dealloc
{
	[image release];
	[imageView release];
	
    [super dealloc];
}


@end
