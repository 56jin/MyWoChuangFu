//
//  ChooseNumCell.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/11.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "ChooseNumCell.h"

@interface ChooseNumCell()

@end

@implementation ChooseNumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    
    return self;
}


- (void)addSubviews
{
    _SelectedimgView = [[UIImageView alloc] init];
    _SelectedimgView.frame = CGRectMake(280, 20, 18, 15);
    _SelectedimgView.image = [UIImage imageNamed:@"iocn_right"];
    [self.contentView addSubview:_SelectedimgView];
    [_SelectedimgView release];
    
    _numLable = [[UILabel alloc] init];
    _numLable.frame = CGRectMake(20, 5, 200,40);
    _numLable.font = [UIFont systemFontOfSize:15.0];
   // _numLable.textColor = [ComponentsFactory createColorByHex:@"#4b4b4b"];
    [self.contentView addSubview:_numLable];
    [_numLable release];
}
@end
