//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyScrollViewDelegate;
@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
    NSInteger pageNum;
    id<MyScrollViewDelegate> myScrollViewDelegate;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) id<MyScrollViewDelegate> myScrollViewDelegate;
- (id)initWithFrameAndImg:(CGRect)frame withImage:(UIImage *)img;
@end
@protocol MyScrollViewDelegate <NSObject>
@optional
- (void)clickPhoto:(MyScrollView *)scrollView;
@end