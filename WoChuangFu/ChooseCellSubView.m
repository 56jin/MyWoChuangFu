//
//  ChooseCellSubView.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/22.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "ChooseCellSubView.h"
#import "CommonMacro.h"

@implementation ChooseCellSubView

+(CGSize)sizeOfView
{
    return CGSizeMake(320, 40);
}


// 必须重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self layout];
    }
    return self;
}

-(void)layout
{
    _lblTttle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH, 50)];
    _btnSelect = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
      UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor orangeColor];
    [self addSubview:_btnSelect];
    [self addSubview:_lblTttle];
    [self addSubview:line];
    self.backgroundColor = [UIColor whiteColor];
  
}
@end
