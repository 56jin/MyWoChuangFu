//
//  LoadMoreView.h
//  WOXTXPro
//
//  Created by Donghai Cheng on 12-7-25.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LABEL_TEXT_FONT_SIZE 12

@interface LoadMoreView : UIView
{
    UIActivityIndicatorView *loadingView;
    UILabel *label;
}
@property(nonatomic,retain)UIActivityIndicatorView *loadingView;
-(void)setActivityIndicatorViewStyle:(UIActionSheetStyle)style;
-(void)startLoading;
-(void)stopLoading;
-(BOOL)isAnimating;
@end
