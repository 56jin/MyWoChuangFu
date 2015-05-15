//
//  UICustomNavigationBar.m
//  YuWOGYPro
//
//  Created by wuyj on 12/6/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import "UICustomNavigationBar.h"

@interface UICustomNavigationBar()
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)NSArray* lButtons;
@property(nonatomic,retain)NSArray* rButtons;


@end

@implementation UICustomNavigationBar
@synthesize title;
@synthesize titleFont;
@synthesize titleColor;
@synthesize backgroundImage;
@synthesize leftButtons;
@synthesize rightButtons;

@synthesize titleLabel = _titleLabel;
@synthesize lButtons = _lButtons;
@synthesize rButtons = _rButtons;


#pragma mark -
#pragma mark set / get
-(NSString*)title{
    return _titleLabel.text;
}

-(void)setTitle:(NSString *)t{
    _titleLabel.text = t;
}

-(UIFont*)titleFont{
    return _titleLabel.font;
}

-(void)setTitleFont:(UIFont *)tf{
    _titleLabel.font = tf;
}

-(UIColor*)titleColor{
    return _titleLabel.textColor;
}

-(void)setTitleColor:(UIColor *)c{
    _titleLabel.textColor = c;
}

-(void)setLeftButtons:(NSArray *)bts{
    for (int i = 0 ; i < [_lButtons count]; i++) {
        UIButton* btn = [_lButtons objectAtIndex:i];
        [btn removeFromSuperview];
    }
    
    self.lButtons = bts;
    CGFloat p = 10.0;
    CGFloat s = 20.0;
    for (int i = 0; i < [bts count]; i++) {
        UIButton* button = [bts objectAtIndex:i];
        UIImage* image = [button imageForState:UIControlStateNormal];
        if (image == nil) {
            image = [button backgroundImageForState:UIControlStateNormal];
        }
        CGRect rect = CGRectMake(p + i*(s + image.size.width),7,image.size.width,image.size.height);
        [button setContentMode:UIViewContentModeScaleAspectFill];
        [button setFrame:rect];
        [button setAlpha:1.0];
        [self addSubview:button];
        
//        [UIView beginAnimations:@"SHOWBUTTON" context:NULL];
//        [UIView setAnimationDuration:0.6];
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:NO];
//        [button setAlpha:1.0];
//        [UIView commitAnimations];
    }
}

-(NSArray*)leftButtons{
    return self.lButtons;
}

-(void)setRightButtons:(NSArray *)bts{
    for (int i = 0 ; i < [_rButtons count]; i++) {
        UIButton* btn = [_rButtons objectAtIndex:i];
        [btn removeFromSuperview];
    }

    self.rButtons = bts;
    CGFloat p = 0.0;
    CGFloat s = 20.0;
    if (bts != nil && [bts count] > 0) {
        UIButton* button = [bts objectAtIndex:0];
        UIImage* image = [button imageForState:UIControlStateNormal];
        if (image == nil) {
            image = [button backgroundImageForState:UIControlStateNormal];
        }
        NSInteger count = [bts count];
        CGFloat pp = 30 + count*image.size.width + s*(count - 1);
        p = 1024 - pp;
    }
    
    for (int i = 0; i < [bts count]; i++) {
        UIButton* button = [bts objectAtIndex:i];
        UIImage* image = [button imageForState:UIControlStateNormal];
        if (image == nil) {
            image = [button backgroundImageForState:UIControlStateNormal];
        }
        CGRect rect = CGRectMake(p + i*(s + image.size.width),7,image.size.width,image.size.height);
        [button setContentMode:UIViewContentModeScaleAspectFill];
        [button setFrame:rect];
        [button setAlpha:1.0];
        [self addSubview:button];
        
//        [UIView beginAnimations:@"SHOWBUTTON" context:NULL];
//        [UIView setAnimationDuration:0.6];
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:NO];
//        [button setAlpha:1.0];
//        [UIView commitAnimations];
    }
}

-(NSArray*)rightButtons{
    return self.rButtons;
}


#pragma mark -
#pragma mark UI
-(void)dealloc{
    [_titleLabel release];
    [_lButtons release];
    [_rButtons release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0,2, 1024, 40)];
        self.titleLabel = lab;
        [lab release];
#ifdef __IPHONE_6_0
        _titleLabel.textAlignment = NSTextAlignmentCenter;
#else
        _titleLabel.textAlignment = UITextAlignmentCenter;
#endif
        _titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        [_titleLabel release];
    }
    return self;
}


-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    UIImage* image = [UIImage imageNamed:self.backgroundImage];
    [image drawInRect:rect];
}


@end
