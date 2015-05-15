//
//  LoadMoreView.m
//  WOXTXPro
//
//  Created by Donghai Cheng on 12-7-25.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import "LoadMoreView.h"

@implementation LoadMoreView
@synthesize loadingView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        loadingView.tag = 11;
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        loadingView.center = CGPointMake(self.frame.size.height/2, self.frame.size.height/2);
        label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height + 5, 0, self.frame.size.width-25, self.frame.size.height)];
        label.text = @"正在加载更多";
        label.hidden = YES;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [ComponentsFactory createColorByHex:@"#7C7C7C"];
        label.font = [UIFont systemFontOfSize:LABEL_TEXT_FONT_SIZE];
        [self addSubview:loadingView];
        [self addSubview:label];
 
    }
    return self;
}
-(void)setActivityIndicatorViewStyle:(UIActionSheetStyle)style
{
    [loadingView setActivityIndicatorViewStyle:style];
}
-(void)startLoading
{
    [loadingView startAnimating];
    label.hidden = NO;
}

-(BOOL)isAnimating
{
    return [loadingView isAnimating];
}

-(void)stopLoading
{
    [loadingView stopAnimating];
    label.hidden = YES;
}

- (void)dealloc {
    [loadingView release];
    [label release];
    [super dealloc];
}

@end
