//
//  MyPrivilegeView.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-5.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "MyPrivilegeView.h"

@implementation MyPrivilegeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIImage *image = [UIImage imageNamed:@"toBeContinued"];
    CGSize imageSize = image.size;
    UIImageView *imgView = [[UIImageView alloc] init];
    CGPoint origin = CGPointMake((self.frame.size.width-imageSize.width)/2.0,(self.frame.size.height-imageSize.height-48)/2.0);
    imgView.frame = (CGRect){origin,imageSize};
    imgView.image = image;
    [self addSubview:imgView];
    [imgView release];
}

@end
