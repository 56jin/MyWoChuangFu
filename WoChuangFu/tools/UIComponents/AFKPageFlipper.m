//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//
//  Modified by Reefaq Mohammed on 16/07/11.

//
#import "AFKPageFlipper.h"

#define kAnimationKey @"ViewAnimation"

#pragma mark -
#pragma mark UIView helpers
@interface UIView(Extended) 

- (UIImage *) imageByRenderingView;

@end

@implementation UIView(Extended)

- (UIImage *) imageByRenderingView 
{
	CGFloat oldAlpha = self.alpha;
	
	self.alpha = 1;
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.alpha = oldAlpha;
	
	return resultingImage;
}

@end

#pragma mark -
#pragma mark Private interface
@implementation AFKPageFlipper

#pragma mark -
#pragma mark Flip functionality
@synthesize pageDifference,numberOfPages,animating,animationType;

@synthesize myNewView;
@synthesize delegate;

- (CATransition*)getAnimation:(NSString*)subTypeString timeInterval:(CFTimeInterval)interval
{
	CATransition* animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:subTypeString];
	[animation setDuration:interval];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

-(void)setMyNewView:(UIView *) value 
{
	if (myNewView) {
		[myNewView release];
	}
	
	myNewView = [value retain];
}

- (void)initAFKPageFlipperAnimationFlip
{
    NSAutoreleasePool* newpool = [[NSAutoreleasePool alloc] init];
	// Create screenshots of view
	UIImage *currentImage = [self.currentView imageByRenderingView];
	UIImage *newImage = [self.myNewView imageByRenderingView];
	
	// Hide existing views
	[self.currentView setHidden:TRUE];
	[self.myNewView setHidden:TRUE];	
	self.currentView.alpha = 0;
	self.myNewView.alpha = 0;
	
	// Create representational layers
	CGRect rect = self.bounds;
	rect.size.width /= 2;
	
	backgroundAnimationLayer = [CALayer layer];
	backgroundAnimationLayer.frame = self.bounds;
	backgroundAnimationLayer.zPosition = -300000;
	
	CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = rect;
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;
	
	[backgroundAnimationLayer addSublayer:leftLayer];
	
	rect.origin.x = rect.size.width;
	
	CALayer *rightLayer = [CALayer layer];
	rightLayer.frame = rect;
	rightLayer.masksToBounds = YES;
	rightLayer.contentsGravity = kCAGravityRight;
	
	[backgroundAnimationLayer addSublayer:rightLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		leftLayer.contents = (id) [newImage CGImage];
		rightLayer.contents = (id) [currentImage CGImage];
	} else {
		leftLayer.contents = (id) [currentImage CGImage];
		rightLayer.contents = (id) [newImage CGImage];
	}
	
	[self.layer addSublayer:backgroundAnimationLayer];
	
	rect.origin.x = 0;
	
	flipAnimationLayer = [CATransformLayer layer];
	flipAnimationLayer.anchorPoint = CGPointMake(1.0, 0.5);
	flipAnimationLayer.frame = rect;
	
	blankFlipAnimationLayerOnLeft1 = [CATransformLayer layer];
	blankFlipAnimationLayerOnLeft1.anchorPoint = CGPointMake(1.0, 0.5);
	blankFlipAnimationLayerOnLeft1.frame = rect;
	blankFlipAnimationLayerOnLeft1.zPosition = -250000;
	
	blankFlipAnimationLayerOnRight1 = [CATransformLayer layer];
	blankFlipAnimationLayerOnRight1.anchorPoint = CGPointMake(1.0, 0.5);
	blankFlipAnimationLayerOnRight1.frame = rect;
	blankFlipAnimationLayerOnRight1.zPosition = 250000;
	
	
	blankFlipAnimationLayerOnLeft2 = [CATransformLayer layer];
	blankFlipAnimationLayerOnLeft2.anchorPoint = CGPointMake(1.0, 0.5);
	blankFlipAnimationLayerOnLeft2.frame = rect;
	blankFlipAnimationLayerOnLeft2.zPosition = -260000;
	
	blankFlipAnimationLayerOnRight2 = [CATransformLayer layer];
	blankFlipAnimationLayerOnRight2.anchorPoint = CGPointMake(1.0, 0.5);
	blankFlipAnimationLayerOnRight2.frame = rect;
	blankFlipAnimationLayerOnRight2.zPosition = 350000;
	
	[self.layer addSublayer:flipAnimationLayer];
	if (pageDifference > 1) {
		[self.layer addSublayer:blankFlipAnimationLayerOnLeft1];
		[self.layer addSublayer:blankFlipAnimationLayerOnRight1];
		if (pageDifference > 2) {
			[self.layer addSublayer:blankFlipAnimationLayerOnLeft2];
			[self.layer addSublayer:blankFlipAnimationLayerOnRight2];
		}
	}
	
	// start
	CALayer *blankBackLayerForLayerLeft = [CALayer layer];
	blankBackLayerForLayerLeft.frame = blankFlipAnimationLayerOnLeft1.bounds;
	blankBackLayerForLayerLeft.doubleSided = NO;
	blankBackLayerForLayerLeft.masksToBounds = YES;
	[blankFlipAnimationLayerOnLeft1 addSublayer:blankBackLayerForLayerLeft];
	
	CALayer *blankFrontLayerForLayerLeft = [CALayer layer];
	blankFrontLayerForLayerLeft.frame = blankFlipAnimationLayerOnLeft1.bounds;
	blankFrontLayerForLayerLeft.doubleSided = NO;
	blankFrontLayerForLayerLeft.masksToBounds = YES;
	blankFrontLayerForLayerLeft.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[blankFlipAnimationLayerOnLeft1 addSublayer:blankFrontLayerForLayerLeft];
	
	CALayer *blankBackLayerForLayerRight = [CALayer layer];
	blankBackLayerForLayerRight.frame = blankFlipAnimationLayerOnRight1.bounds;
	blankBackLayerForLayerRight.doubleSided = NO;
	blankBackLayerForLayerRight.masksToBounds = YES;
	[blankFlipAnimationLayerOnRight1 addSublayer:blankBackLayerForLayerRight];
	
	CALayer *blankFrontLayerForLayerRight = [CALayer layer];
	blankFrontLayerForLayerRight.frame = blankFlipAnimationLayerOnRight1.bounds;
	blankFrontLayerForLayerRight.doubleSided = NO;
	blankFrontLayerForLayerRight.masksToBounds = YES;
	blankFrontLayerForLayerRight.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[blankFlipAnimationLayerOnRight1 addSublayer:blankFrontLayerForLayerRight];
	// end	
	
	// start
	CALayer *blankBackLayerForLayerLeft2 = [CALayer layer];
	blankBackLayerForLayerLeft2.frame = blankFlipAnimationLayerOnLeft2.bounds;
	blankBackLayerForLayerLeft2.doubleSided = NO;
	blankBackLayerForLayerLeft2.masksToBounds = YES;
	[blankFlipAnimationLayerOnLeft2 addSublayer:blankBackLayerForLayerLeft2];
	
	CALayer *blankFrontLayerForLayerLeft2 = [CALayer layer];
	blankFrontLayerForLayerLeft2.frame = blankFlipAnimationLayerOnLeft2.bounds;
	blankFrontLayerForLayerLeft2.doubleSided = NO;
	blankFrontLayerForLayerLeft2.masksToBounds = YES;
	blankFrontLayerForLayerLeft2.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[blankFlipAnimationLayerOnLeft2 addSublayer:blankFrontLayerForLayerLeft2];

	CALayer *blankBackLayerForLayerRight2 = [CALayer layer];
	blankBackLayerForLayerRight2.frame = blankFlipAnimationLayerOnRight2.bounds;
	blankBackLayerForLayerRight2.doubleSided = NO;
	blankBackLayerForLayerRight2.masksToBounds = YES;
	[blankFlipAnimationLayerOnRight2 addSublayer:blankBackLayerForLayerRight2];
	
	CALayer *blankFrontLayerForLayerRight2 = [CALayer layer];
	blankFrontLayerForLayerRight2.frame = blankFlipAnimationLayerOnRight2.bounds;
	blankFrontLayerForLayerRight2.doubleSided = NO;
	blankFrontLayerForLayerRight2.masksToBounds = YES;
	blankFrontLayerForLayerRight2.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[blankFlipAnimationLayerOnRight2 addSublayer:blankFrontLayerForLayerRight2];
	// end	
	
	CALayer *backLayer = [CALayer layer];
	backLayer.frame = flipAnimationLayer.bounds;
	backLayer.doubleSided = NO;
	backLayer.masksToBounds = YES;
	[flipAnimationLayer addSublayer:backLayer];
	
	CALayer *frontLayer = [CALayer layer];
	frontLayer.frame = flipAnimationLayer.bounds;
	frontLayer.doubleSided = NO;
	frontLayer.masksToBounds = YES;
	frontLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[flipAnimationLayer addSublayer:frontLayer];
	
	// shadows
	frontLayerShadow = [CALayer layer];
	frontLayerShadow.frame = frontLayer.bounds;
	frontLayerShadow.doubleSided = NO;
	frontLayerShadow.masksToBounds = YES;
	frontLayerShadow.opacity = 0;
	frontLayerShadow.backgroundColor = [UIColor blackColor].CGColor;
	[frontLayer addSublayer:frontLayerShadow];
    
	backLayerShadow = [CALayer layer];
	backLayerShadow.frame = backLayer.bounds;
	backLayerShadow.doubleSided = NO;
	backLayerShadow.masksToBounds = YES;
	backLayerShadow.opacity = 0;
	backLayerShadow.backgroundColor = [UIColor blackColor].CGColor;
	[backLayer addSublayer:backLayerShadow];
	
	leftLayerShadow = [CALayer layer];
	leftLayerShadow.frame = leftLayer.bounds;
	leftLayerShadow.doubleSided = NO;
	leftLayerShadow.masksToBounds = YES;
	leftLayerShadow.opacity = 0.0;
	leftLayerShadow.backgroundColor = [UIColor blackColor].CGColor;
	[leftLayer addSublayer:leftLayerShadow];
	
	rightLayerShadow = [CALayer layer];
	rightLayerShadow.frame = rightLayer.bounds;
	rightLayerShadow.doubleSided = NO;
	rightLayerShadow.masksToBounds = YES;
	rightLayerShadow.opacity = 0.0;
	rightLayerShadow.backgroundColor = [UIColor blackColor].CGColor;
	[rightLayer addSublayer:rightLayerShadow];
	// shadows
    
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	
	UIImage* flipImage;
	
	if (orient == UIInterfaceOrientationPortrait || orient == UIInterfaceOrientationPortraitUpsideDown) {
		flipImage = flipIllusionPortrait;
	}else if (orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight) {
		flipImage = flipIllusionLandscape;
	}
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		backLayer.contents = (id) [currentImage CGImage];
		backLayer.contentsGravity = kCAGravityLeft;
		
		frontLayer.contents = (id) [newImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
		transform.m34 = 1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		transform.m34 = 1.0f / 1500.0f;
		
		if (pageDifference > 1) {
			//start forlayer left
			UIImage* blankImgBLeft = flipImage;
			blankBackLayerForLayerLeft.contents = (id) [blankImgBLeft CGImage];
			blankBackLayerForLayerLeft.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFLeft = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft1.bounds];
			[blankViewFLeft setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgFLeft =  [blankViewFLeft imageByRenderingView];
			blankFrontLayerForLayerLeft.contents = (id) [blankImgFLeft CGImage];
			[blankViewFLeft release];
			blankFrontLayerForLayerLeft.contentsGravity = kCAGravityRight;
			
			//start forlayer right
			UIView* blankViewBRight = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight1.bounds];
			[blankViewBRight setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgBRight =  [blankViewBRight imageByRenderingView];
			blankBackLayerForLayerRight.contents = (id) [blankImgBRight CGImage];
			[blankViewBRight release];
			blankBackLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFRight = flipImage;
			frontLayer.contents = (id) [blankImgFRight CGImage];
			blankFrontLayerForLayerRight.contents = (id) [newImage CGImage];
			blankFrontLayerForLayerRight.contentsGravity = kCAGravityRight;
			
			CATransform3D transformblank = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
			transformblank.m34 = 1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft1.transform = transformblank;
			blankFlipAnimationLayerOnRight1.transform = transformblank;
			transformblank.m34 = 1.0f / 1500.0f;
			
			//end
		}
		
		if (pageDifference > 2) {
			
			//start forlayer left
			UIImage* blankImgBLeft = flipImage;
			blankBackLayerForLayerLeft.contents = (id) [blankImgBLeft CGImage];
			blankBackLayerForLayerLeft.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFLeft = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft1.bounds];
			[blankViewFLeft setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgFLeft =  [blankViewFLeft imageByRenderingView];
			blankFrontLayerForLayerLeft.contents = (id) [blankImgFLeft CGImage];
			[blankViewFLeft release];
			blankFrontLayerForLayerLeft.contentsGravity = kCAGravityRight;
			
			//start forlayer right
			UIView* blankViewBRight = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight1.bounds];
			[blankViewBRight setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgBRight =  [blankViewBRight imageByRenderingView];
			blankBackLayerForLayerRight.contents = (id) [blankImgBRight CGImage];
			[blankViewBRight release];
			blankBackLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFRight = flipImage;
			blankFrontLayerForLayerRight.contents = (id) [blankImgFRight CGImage];
			blankFrontLayerForLayerRight.contentsGravity = kCAGravityRight;
			
			
			CATransform3D transformblank = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
			transformblank.m34 = 1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft1.transform = transformblank;
			blankFlipAnimationLayerOnRight1.transform = transformblank;
			transformblank.m34 = 1.0f / 1500.0f;
			
			//end	
			
			//start forlayer left2
			UIImage* blankImgBLeft2 = flipImage;
			blankBackLayerForLayerLeft2.contents = (id) [blankImgBLeft2 CGImage];
			blankBackLayerForLayerLeft2.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFLeft2 = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft2.bounds];
			[blankViewFLeft2 setBackgroundColor:RGBACOLOR(0, 0, 0, 0)];
			UIImage* blankImgFLeft2 =  [blankViewFLeft2 imageByRenderingView];
			blankFrontLayerForLayerLeft2.contents = (id) [blankImgFLeft2 CGImage];
			[blankViewFLeft2 release];
			blankFrontLayerForLayerLeft2.contentsGravity = kCAGravityRight;
			
			//start forlayer right2
			UIView* blankViewBRight2 = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight2.bounds];
			[blankViewBRight2 setBackgroundColor:RGBACOLOR(0, 0, 0, 0)];
			UIImage* blankImgBRight2 =  [blankViewBRight2 imageByRenderingView];
			blankBackLayerForLayerRight2.contents = (id) [blankImgBRight2 CGImage];
			[blankViewBRight2 release];
			blankBackLayerForLayerRight2.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFRight2 = flipImage;
			blankFrontLayerForLayerRight2.contents = (id) [newImage CGImage];
			frontLayer.contents = (id) [blankImgFRight2 CGImage];
			blankFrontLayerForLayerRight2.contentsGravity = kCAGravityRight;
			
			
			CATransform3D transformblank2 = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
			transformblank2.m34 = 1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft2.transform = transformblank2;
			blankFlipAnimationLayerOnRight2.transform = transformblank2;
			transformblank2.m34 = 1.0f / 1500.0f;
			
			//end
		}
		
		currentAngle = startFlipAngle = 0;
		endFlipAngle = -M_PI;
	} else {
		backLayer.contentsGravity = kCAGravityLeft;
		backLayer.contents = (id) [newImage CGImage];
		
		frontLayer.contents = (id) [currentImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(-M_PI / 1.1 , 0.0, 1.0, 0.0);
		transform.m34 = -1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		transform.m34 = -1.0f / 1500.0f;
		
		if (pageDifference > 1) {
			//start forlayer left
			UIView* blankViewBLeft = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft1.frame];
			[blankViewBLeft setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgBLeft =  [blankViewBLeft imageByRenderingView];
			blankBackLayerForLayerLeft.contents = (id) [blankImgBLeft CGImage];
			[blankViewBLeft release];
			blankBackLayerForLayerLeft.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFLeft = flipImage;
			blankFrontLayerForLayerLeft.contents = (id) [blankImgFLeft CGImage];
			blankFrontLayerForLayerLeft.contentsGravity = kCAGravityRight;
			
			//start forlayer right
			UIImage* blankImgBRight = flipImage;
			blankBackLayerForLayerRight.contents = (id) [newImage CGImage];
			backLayer.contents = (id) [blankImgBRight CGImage];
			blankBackLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFRight = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight1.frame];
			[blankViewFRight setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgFRight =  [blankViewFRight imageByRenderingView];
			blankFrontLayerForLayerRight.contents = (id) [blankImgFRight CGImage];
			[blankViewFRight release];
			blankFrontLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			CATransform3D transformblank = CATransform3DMakeRotation(-M_PI / 1.1, 0.0, 1.0, 0.0);
			transformblank.m34 = -1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft1.transform = transformblank;
			blankFlipAnimationLayerOnRight1.transform = transformblank;
			
			//end
		}
		
		if (pageDifference > 2) {
			//start forlayer left
			UIView* blankViewBLeft = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft1.frame];
			[blankViewBLeft setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgBLeft =  [blankViewBLeft imageByRenderingView];
			blankBackLayerForLayerLeft.contents = (id) [blankImgBLeft CGImage];
			[blankViewBLeft release];
			blankBackLayerForLayerLeft.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFLeft = flipImage;
			blankFrontLayerForLayerLeft.contents = (id) [blankImgFLeft CGImage];
			blankFrontLayerForLayerLeft.contentsGravity = kCAGravityRight;
			
			//start forlayer right
			UIImage* blankImgBRight = flipImage;
			blankBackLayerForLayerRight.contents = (id) [blankImgBRight CGImage];
			blankBackLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFRight = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight1.frame];
			[blankViewFRight setBackgroundColor:RGBACOLOR(0,0,0,0)];
			UIImage* blankImgFRight =  [blankViewFRight imageByRenderingView];
			blankFrontLayerForLayerRight.contents = (id) [blankImgFRight CGImage];
			[blankViewFRight release];
			blankFrontLayerForLayerRight.contentsGravity = kCAGravityLeft;
			
			CATransform3D transformblank = CATransform3DMakeRotation(-M_PI / 1.1, 0.0, 1.0, 0.0);
			transformblank.m34 = -1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft1.transform = transformblank;
			blankFlipAnimationLayerOnRight1.transform = transformblank;
			
			//end
			
			//start2 forlayer left2
			UIView* blankViewBLeft2 = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnLeft2.frame];
			[blankViewBLeft2 setBackgroundColor:RGBACOLOR(255,255,255,0)];
			UIImage* blankImgBLeft2 =  [blankViewBLeft2 imageByRenderingView];
			blankBackLayerForLayerLeft2.contents = (id) [blankImgBLeft2 CGImage];
			[blankViewBLeft2 release];
			blankBackLayerForLayerLeft2.contentsGravity = kCAGravityLeft;
			
			UIImage* blankImgFLeft2 = flipImage;
			blankFrontLayerForLayerLeft2.contents = (id) [blankImgFLeft2 CGImage];
			blankFrontLayerForLayerLeft2.contentsGravity = kCAGravityRight;
			
			//start forlayer right2
			UIImage* blankImgBRight2 = flipImage;
			blankBackLayerForLayerRight2.contents = (id) [newImage CGImage];
			backLayer.contents = (id) [blankImgBRight2 CGImage];
			blankBackLayerForLayerRight2.contentsGravity = kCAGravityLeft;
			
			UIView* blankViewFRight2 = [[UIView alloc] initWithFrame:blankFlipAnimationLayerOnRight2.frame];
			[blankViewFRight2 setBackgroundColor:RGBACOLOR(252,252,252,0)];
			UIImage* blankImgFRight2 =  [blankViewFRight2 imageByRenderingView];
			blankFrontLayerForLayerRight2.contents = (id) [blankImgFRight2 CGImage];
			[blankViewFRight2 release];
			blankFrontLayerForLayerRight2.contentsGravity = kCAGravityLeft;
			
			CATransform3D transformblank2 = CATransform3DMakeRotation(-M_PI / 1.1, 0.0, 1.0, 0.0);
			transformblank2.m34 = -1.0f / 2500.0f;
			
			blankFlipAnimationLayerOnLeft2.transform = transformblank2;
			blankFlipAnimationLayerOnRight2.transform = transformblank2;
			
			//end2			
		}
		
		currentAngle = startFlipAngle = -M_PI ;
		endFlipAngle = 0;
	}
	[newpool release];
}

-(void)initAFKPageFlipperAnimationHorizontal
{
    NSAutoreleasePool* newpool = [[NSAutoreleasePool alloc] init];
    
	// Create screenshots of view
	UIImage* headImage = [[self.currentView viewWithTag:1000] imageByRenderingView];
    UIImage* footImage = [[self.currentView viewWithTag:1002] imageByRenderingView];
    UIImage* currentImage = [[self.currentView viewWithTag:1001] imageByRenderingView];
    UIImage* newImage = [[self.myNewView viewWithTag:1001] imageByRenderingView];
    
    // Hide existing views
	[self.currentView setHidden:TRUE];
	[self.myNewView setHidden:TRUE];	
	self.currentView.alpha = 0;
	self.myNewView.alpha = 0;
    
    headView = [[UIImageView alloc] initWithImage:headImage];
    footView = [[UIImageView alloc] initWithImage:footImage];

    currentImageView = [[UIImageView alloc] initWithImage:currentImage];
    newImageView = [[UIImageView alloc] initWithImage:newImage];
    
    CGRect headRect = headView.frame;
    CGRect contRect = currentImageView.frame;
    CGRect footRect = footView.frame;
    
//    NSLog(@"head.x:%f,head.y:%f,head.w:%f,head.h:%f",headRect.origin.x,headRect.origin.y,headRect.size.width,headRect.size.height);
//    NSLog(@"cont.x:%f,cont.y:%f,cont.w:%f,cont.h:%f",contRect.origin.x,contRect.origin.y,contRect.size.width,contRect.size.height);
//    NSLog(@"foot.x:%f,foot.y:%f,foot.w:%f,foot.h:%f",footRect.origin.x,footRect.origin.y,footRect.size.width,footRect.size.height);
    
    contRect.origin.y = headRect.size.height;
    footRect.origin.y = headRect.size.height+contRect.size.height;
    footView.frame = footRect;
    
    newsContentView = [[UIView alloc] initWithFrame:contRect];
    [newsContentView addSubview:newImageView];
    [newsContentView addSubview:currentImageView];
    
    [self addSubview:headView];
    [self addSubview:newsContentView];
    [self addSubview:footView];
    
    [newpool release];
}

- (void)initFlip 
{
    if(AFKPageFlipperAnimationFlip == animationType){
        [self initAFKPageFlipperAnimationFlip];
    }else if(AFKPageFlipperAnimationHorizontal == animationType){
        [self initAFKPageFlipperAnimationHorizontal];
    }
}

- (void) cleanupAFKPageFlipperAnimationFlip
{
    [backgroundAnimationLayer removeFromSuperlayer];
    [flipAnimationLayer removeFromSuperlayer];
    if (pageDifference > 1) {
        [blankFlipAnimationLayerOnLeft1 removeFromSuperlayer];
        [blankFlipAnimationLayerOnRight1 removeFromSuperlayer];
        blankFlipAnimationLayerOnLeft1 = Nil;
        blankFlipAnimationLayerOnRight1 = Nil;
        
        if (pageDifference > 2) {
            [blankFlipAnimationLayerOnLeft2 removeFromSuperlayer];
            [blankFlipAnimationLayerOnRight2 removeFromSuperlayer];
            blankFlipAnimationLayerOnLeft2 = Nil;
            blankFlipAnimationLayerOnRight2 = Nil;
        }	
    }
    backgroundAnimationLayer = Nil;
    flipAnimationLayer = Nil;
    
    animating = NO;
    
    if (setNewViewOnCompletion) {
        [self.currentView removeFromSuperview];
        self.currentView = self.myNewView;
        self.myNewView = Nil;
    } else {
        [self.myNewView removeFromSuperview];
        self.myNewView = Nil;
    }
    
    setNewViewOnCompletion = NO;
    [self.currentView setHidden:FALSE];
    self.currentView.alpha = 1;
    [self setDisabled:FALSE];
}

- (void) cleanupAFKPageFlipperAnimationHorizontal
{
    [headView removeFromSuperview];
    headView = nil;
    
    [footView removeFromSuperview];
    footView = nil;

    [newsContentView removeFromSuperview];
    newsContentView = nil;
    
    [[newsContentView layer] removeAnimationForKey:kAnimationKey];
    animating = NO;
    
    if (setNewViewOnCompletion) {
        [self.currentView removeFromSuperview];
        self.currentView = self.myNewView;
        self.myNewView = Nil;
    } else {
        [self.myNewView removeFromSuperview];
        self.myNewView = Nil;
    }
    
    setNewViewOnCompletion = NO;
    [self.currentView setHidden:FALSE];
    self.currentView.alpha = 1;
    [self setDisabled:FALSE];
}

- (void) cleanupFlip 
{
    if(AFKPageFlipperAnimationFlip == animationType){
        [self cleanupAFKPageFlipperAnimationFlip];
    }else if(AFKPageFlipperAnimationHorizontal == animationType){
        [self cleanupAFKPageFlipperAnimationHorizontal];
    }
    
    if (nil!= delegate && [delegate respondsToSelector:@selector(afkPageFlipperAnimationDidEnd:)]) {
        [delegate afkPageFlipperAnimationDidEnd:self];
    }
}

- (void) setFlipProgress3:(NSDictionary*)dict
{
	float progress =[[dict objectForKey:@"PROGRESS"] floatValue];
	BOOL setDelegate = [[dict objectForKey:@"DELEGATE"] boolValue];
	BOOL animate = [[dict objectForKey:@"ANIMATE"] boolValue];
	
	float newAngle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
	float duration = animate ? 0.5 * fabs((newAngle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
	
	duration = 0.5;
	
	CATransform3D endTransform = CATransform3DIdentity;
	endTransform.m34 = 1.0f / 2500.0f;
	endTransform = CATransform3DRotate(endTransform, newAngle, 0.0, 1.0, 0.0);	
	
	[blankFlipAnimationLayerOnLeft2 removeAllAnimations];
	[blankFlipAnimationLayerOnRight2 removeAllAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	blankFlipAnimationLayerOnLeft2.transform = endTransform;
	blankFlipAnimationLayerOnRight2.transform = endTransform;
	[UIView commitAnimations];
	
	if (setDelegate) {
		[self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];
	}
}

- (void) setFlipProgress2:(NSDictionary*)dict
{
	float progress =[[dict objectForKey:@"PROGRESS"] floatValue];
	BOOL setDelegate = [[dict objectForKey:@"DELEGATE"] boolValue];
	BOOL animate = [[dict objectForKey:@"ANIMATE"] boolValue];
	
	float newAngle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
	float duration = animate ? 0.5 * fabs((newAngle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
	
	duration = 0.5;
	
	CATransform3D endTransform = CATransform3DIdentity;
	endTransform.m34 = 1.0f / 2500.0f;
	endTransform = CATransform3DRotate(endTransform, newAngle, 0.0, 1.0, 0.0);	
	
	[blankFlipAnimationLayerOnLeft1 removeAllAnimations];
	[blankFlipAnimationLayerOnRight1 removeAllAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	blankFlipAnimationLayerOnLeft1.transform = endTransform;	
	blankFlipAnimationLayerOnRight1.transform = endTransform;
	[UIView commitAnimations];
	
	if (pageDifference > 2) {
		NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
		[dictionary setObject:[NSString stringWithFormat:@"%f",progress] forKey:@"PROGRESS"];
		[dictionary setObject:[NSString stringWithFormat:@"%d",setDelegate] forKey:@"DELEGATE"];
		[dictionary setObject:[NSString stringWithFormat:@"%d",animate] forKey:@"ANIMATE"];	
		
		[self performSelector:@selector(setFlipProgress3:) withObject:dictionary afterDelay:0.12];
		
		[dictionary release];
	}else {
		if (setDelegate) {
			[self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];
		}
	}
}

- (void) setFlipProgress:(float) progress setDelegate:(BOOL) setDelegate animate:(BOOL) animate
{
	float newAngle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
	float duration = animate ? 0.5 * fabs((newAngle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
	
	currentAngle = newAngle;
    NSLog(@"angle:%f",currentAngle);
	
	CATransform3D endTransform = CATransform3DIdentity;
	endTransform.m34 = 1.0f / 2500.0f;
	endTransform = CATransform3DRotate(endTransform, newAngle, 0.0, 1.0, 0.0);	
	
	[flipAnimationLayer removeAllAnimations];
	
	// shadows
	CGFloat newShadowOpacity = progress;
	if (endFlipAngle > startFlipAngle) newShadowOpacity = 1.0 - progress;
	// shadows
    
	if (duration < 0.35) {
		duration = 0.35;
	}
	
	[UIView beginAnimations:@"FLIP1" context:nil];
	[UIView setAnimationDuration:duration];
	flipAnimationLayer.transform =  endTransform;
	
	// shadows
	frontLayerShadow.opacity = 1.0 - newShadowOpacity;
	backLayerShadow.opacity = newShadowOpacity;
	leftLayerShadow.opacity = 0.5 - newShadowOpacity;
	rightLayerShadow.opacity = newShadowOpacity - 0.5;
	// shadows
	[UIView commitAnimations];
	
	if (pageDifference > 1) {
		NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[NSString stringWithFormat:@"%f",progress] forKey:@"PROGRESS"];
		[dict setObject:[NSString stringWithFormat:@"%d",setDelegate] forKey:@"DELEGATE"];
		[dict setObject:[NSString stringWithFormat:@"%d",animate] forKey:@"ANIMATE"];	
		
		[self performSelector:@selector(setFlipProgress2:) withObject:dict afterDelay:0.12];
		
		[dict release];
	}else {
		if (setDelegate) {
			[self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];
		}
	}
}

- (void) flipPage 
{
	[self setFlipProgress:1.0 setDelegate:YES animate:YES];
}

- (void)setFlipperAnimationhorizontal:(NSString*)subTypeString timeInterval:(CFTimeInterval)interval animate:(BOOL)animate
{
    if(animate){
        NSUInteger current = [[newsContentView subviews] indexOfObject:currentImageView];
        NSUInteger new = [[newsContentView subviews] indexOfObject:newImageView];
        
        transitionHorizontal = [self getAnimation:subTypeString timeInterval:interval/2.0];
        [[newsContentView layer] addAnimation:transitionHorizontal forKey:kAnimationKey];
        
        [newsContentView exchangeSubviewAtIndex:current withSubviewAtIndex:new];
        
        [self performSelector:@selector(cleanupFlip) withObject:nil afterDelay:interval/2.0];
    }else{
        [self performSelector:@selector(cleanupFlip) withObject:nil afterDelay:interval/2.0];
    }
}

#pragma mark -
#pragma mark Animation management
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context 
{
	[self cleanupFlip];
}

#pragma mark -
#pragma mark Properties
@synthesize currentView;

- (void) setCurrentView:(UIView *) value 
{
	if (currentView) {
		[currentView release];
	}
	
	currentView = [value retain];
}

@synthesize currentPage;

- (BOOL) doSetCurrentPage:(NSInteger) value 
{
	if (value == currentPage) {
		return FALSE;
	}
	
	flipDirection = value < currentPage ? AFKPageFlipperDirectionRight : AFKPageFlipperDirectionLeft;
	
	currentPage = value;
	
	self.myNewView = [self.dataSource viewForPage:value inFlipper:self];
    
	[self addSubview:self.myNewView];
	
	return TRUE;
}	

- (void) setCurrentPage:(NSInteger) value 
{
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	setNewViewOnCompletion = YES;
	animating = NO;
	
	[self.myNewView setHidden:TRUE];
	self.myNewView.alpha = 0;
	
	[UIView beginAnimations:@"" context:Nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	[self.myNewView setHidden:FALSE];	
	self.myNewView.alpha = 1;
	
	[UIView commitAnimations];
} 

- (void) setCurrentPage:(NSInteger)value animated:(BOOL)animated 
{
	pageDifference = fabs(value - currentPage);
	
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	setNewViewOnCompletion = YES;
	animating = YES;
	
	if (animated) {
		[self setDisabled:TRUE];
		[self initFlip];
        
        if (AFKPageFlipperAnimationFlip == animationType) {
            if (pageDifference > 1) {
                NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setObject:[NSString stringWithFormat:@"%f",0.01] forKey:@"PROGRESS"];
                [dictionary setObject:[NSString stringWithFormat:@"%d",NO] forKey:@"DELEGATE"];
                [dictionary setObject:[NSString stringWithFormat:@"%d",NO] forKey:@"ANIMATE"];	
                
                //multi-flip-for 2
                [self setFlipProgress2:dictionary];
                
                if (pageDifference > 2) {
                    //multi flip-for more than 2
                    [self setFlipProgress3:dictionary];
                }
                
                [dictionary release];
            }
            [self performSelector:@selector(flipPage) withObject:Nil afterDelay:0.000];
        }else if(AFKPageFlipperAnimationHorizontal == animationType){
            if(AFKPageFlipperDirectionLeft == flipDirection){
                [self setFlipperAnimationhorizontal:kCATransitionFromRight timeInterval:0.5f animate:YES];
            }else if(AFKPageFlipperDirectionRight == flipDirection){
                [self setFlipperAnimationhorizontal:kCATransitionFromLeft timeInterval:0.5f animate:YES];
            }
        }
	} else {
        if(AFKPageFlipperAnimationFlip == animationType){
            [self animationDidStop:Nil finished:[NSNumber numberWithBool:NO] context:Nil];
        }else if(AFKPageFlipperAnimationHorizontal == animationType){
            [self setFlipperAnimationhorizontal:Nil timeInterval:0.5f animate:NO];
        }
	}
}

@synthesize dataSource;

- (void) setDataSource:(NSObject <AFKPageFlipperDataSource>*) value 
{
	if (dataSource) {
		[dataSource release];
	}
	
	dataSource = [value retain];
	numberOfPages = [dataSource numberOfPagesForPageFlipper:self];
	self.currentPage = 1;
}

@synthesize disabled;

- (void) setDisabled:(BOOL)value 
{
	disabled = value;
	
	self.userInteractionEnabled = !value;
	
	for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
		recognizer.enabled = !value;
	}
}

#pragma mark -
#pragma mark Touch management
- (void) pannedAFKPageFlipperAnimationFlip:(UIPanGestureRecognizer *) recognizer
{
    static BOOL hasFailed;
	static BOOL initialized;
	
	static NSInteger oldPage;
	
	float translation = [recognizer translationInView:self].x;
	
	float progress = translation / self.bounds.size.width;
	
	if (flipDirection == AFKPageFlipperDirectionLeft) {
		progress = MIN(progress, 0);
	} else {
		progress = MAX(progress, 0);
	}
	
	pageDifference = 1;
	
	switch(recognizer.state) {
		case UIGestureRecognizerStateBegan:
			if (!animating) {
				hasFailed = FALSE;
				initialized = FALSE;
				animating = NO;
				setNewViewOnCompletion = NO;
			}
			break;
			
		case UIGestureRecognizerStateChanged:
			if (hasFailed) {
				return;
			}
			
			if (!initialized) {
				oldPage = self.currentPage;
				
				if (translation > 0) {
					if (self.currentPage > 1) {
						[self doSetCurrentPage:self.currentPage - 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				} else {
					if (self.currentPage < numberOfPages) {
						[self doSetCurrentPage:self.currentPage + 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				}
				
				hasFailed = NO;
				initialized = TRUE;
				animating = YES;
				setNewViewOnCompletion = NO;
				
				[self initFlip];
			}
			
			[self setFlipProgress:fabs(progress) setDelegate:NO animate:YES];
			break;
			
		case UIGestureRecognizerStateFailed:
			[self setDisabled:TRUE];
			[self setFlipProgress:0.0 setDelegate:YES animate:YES];
			currentPage = oldPage;
			break;
			
		case UIGestureRecognizerStateRecognized:
			if (initialized) {
				if (hasFailed) {
					[self setDisabled:TRUE];
					[self setFlipProgress:0.0 setDelegate:YES animate:YES];
					currentPage = oldPage;
					return;
				}
                
                if (flipDirection == AFKPageFlipperDirectionLeft) {
                    if (currentAngle > -3*M_PI/4) {
                        [self setDisabled:TRUE];
                        setNewViewOnCompletion = YES;
                        [self setFlipProgress:1.0 setDelegate:YES animate:YES];
                    }else {
                        [self setDisabled:TRUE];
                        [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                        currentPage = oldPage;
                    } 
                }else {
                    if (currentAngle < -1*M_PI/4) {
                        [self setDisabled:TRUE];
                        setNewViewOnCompletion = YES;
                        [self setFlipProgress:1.0 setDelegate:YES animate:YES];
                    }else {
                        [self setDisabled:TRUE];
                        [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                        currentPage = oldPage;
                    } 
                    
                }
                if (delegate && [delegate respondsToSelector:@selector(afkPageFlipper:fliperNewPageOnComplate:flipDirection:)]) {
                    [delegate afkPageFlipper:self fliperNewPageOnComplate:setNewViewOnCompletion flipDirection:flipDirection];
                }
			}
			break;
            
        default:
            break;
	}
}

-(void) pannedAFKPageFlipperAnimationhorizontal:(UIPanGestureRecognizer *) recognizer
{
    static BOOL hasFailed;
	static BOOL initialized;
	
	static NSInteger oldPage;
	
	float translation = [recognizer translationInView:self].x;
	
	pageDifference = 1;
    
    switch(recognizer.state) {
		case UIGestureRecognizerStateBegan:
			if (!animating) {
				hasFailed = FALSE;
				initialized = FALSE;
				animating = NO;
				setNewViewOnCompletion = NO;
			}
			break;
		case UIGestureRecognizerStateChanged:
			if (hasFailed) {
				return;
			}
			
			if (!initialized) {
				oldPage = self.currentPage;
				
				if (translation > 0) {
					if (self.currentPage > 1) {
						[self doSetCurrentPage:self.currentPage - 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				} else {
					if (self.currentPage < numberOfPages) {
						[self doSetCurrentPage:self.currentPage + 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				}
				
				hasFailed = NO;
				initialized = TRUE;
				animating = YES;
				setNewViewOnCompletion = NO;
                
                [self initFlip];
			}
			break;
			
		case UIGestureRecognizerStateFailed:
			[self setDisabled:TRUE];
            [self setFlipperAnimationhorizontal:Nil timeInterval:0.5f animate:NO];
			currentPage = oldPage;
			break;
			
		case UIGestureRecognizerStateRecognized:
			if (initialized) {
				if (hasFailed) {
					[self setDisabled:TRUE];
                    [self setFlipperAnimationhorizontal:Nil timeInterval:0.5f animate:NO];
					currentPage = oldPage;
					return;
				}
                
                if(AFKPageFlipperDirectionLeft == flipDirection){
                    [self setDisabled:TRUE];
                    setNewViewOnCompletion = YES;
                    [self setFlipperAnimationhorizontal:kCATransitionFromRight timeInterval:0.8f animate:YES];
                }else if(AFKPageFlipperDirectionRight == flipDirection){
                    [self setDisabled:TRUE];
                    setNewViewOnCompletion = YES;
                    [self setFlipperAnimationhorizontal:kCATransitionFromLeft timeInterval:0.8f animate:YES];
                }
			}
			break;
            
        default:
            break;
	}
}

- (void) panned:(UIPanGestureRecognizer *) recognizer 
{
    if(AFKPageFlipperAnimationFlip == animationType){
        [self pannedAFKPageFlipperAnimationFlip:recognizer];
    }else if(AFKPageFlipperAnimationHorizontal == animationType){
        [self pannedAFKPageFlipperAnimationhorizontal:recognizer];
    }
}

#pragma mark -
#pragma mark Frame management
- (void) setFrame:(CGRect) value 
{
	super.frame = value;
	
	numberOfPages = [dataSource numberOfPagesForPageFlipper:self];
	
	if (self.currentPage > numberOfPages) {
		self.currentPage = numberOfPages;
	}
}

#pragma mark -
#pragma mark Initialization and memory management
+ (Class) layerClass 
{
	return [CATransformLayer class];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
		UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)] autorelease];
		[panRecognizer setMaximumNumberOfTouches:1];
		[self addGestureRecognizer:panRecognizer];
		
		flipIllusionPortrait = [[UIImage imageNamed:@"flip-illusion-oriented.jpg"] retain];
		flipIllusionLandscape = [[UIImage imageNamed:@"flip-illusion.png"] retain];
		
		animating = FALSE;
    }
    return self;
}

- (void)dealloc 
{
	self.dataSource = Nil;
	self.currentView = Nil;
	self.myNewView = Nil;
    [super dealloc];
}

@end
