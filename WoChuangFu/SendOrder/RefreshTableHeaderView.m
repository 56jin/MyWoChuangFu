//
//  RefreshTableHeaderView.m
//  SaleToolsKit
//
//  Created by Wu YouJian on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshTableHeaderView.h"
#import "ComponentsFactory.h"

@implementation RefreshTableHeaderView
@synthesize activityView;

-(void)dealloc
{
    [activityView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake((frame.size.width-100)/2.0f,8,20,20 );
		[self addSubview:activityView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-100)/2.0f+24, 6, 150, 25)];
        titleLabel.textColor = [ComponentsFactory createColorByHex:@"#757576"];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.text = @"上拉加载更多";
        titleLabel.tag = 11;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)startRefresh
{
    self.hidden = NO;
    NSString* title = @"加载中";
    UILabel *label = (UILabel *)[self viewWithTag:11];
    label.text = title;
    [activityView startAnimating];
}

-(void)stopRefresh
{
    [activityView stopAnimating];
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
