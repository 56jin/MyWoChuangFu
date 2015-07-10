//
//  PhotoCertIDView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/12.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "PhotoCertIDView.h"

#define ID_TITLE_LABEL_TAG              101
#define ID_VALUE_LABEL_TAG              102
#define NAME_TITLE_LABEL_TAG            103
#define NAME_VALUE_LABEL_TAG            104
#define ADDRESS_TITLE_LABEL_TAG         105
#define ADDRESS_VALUE_LABEL_TAG         106

@implementation PhotoCertIDView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    CGFloat hei = self.frame.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((hei-275)/2.0f, 0, 70, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = @"机主姓名:";
    titleLabel.hidden = YES;
    titleLabel.tag = ID_TITLE_LABEL_TAG;
    [self addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake((hei-275)/2.0f+75, 0, 200, 30)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    valueLabel.font = [UIFont systemFontOfSize:13.0f];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.tag = ID_VALUE_LABEL_TAG;
    valueLabel.hidden = YES;
    [self addSubview:valueLabel];
    [valueLabel release];
    
    
    UILabel *nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((hei-275)/2.0f, 32, 70, 30)];
    nameTitleLabel.backgroundColor = [UIColor clearColor];
    nameTitleLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    nameTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    nameTitleLabel.textAlignment = NSTextAlignmentRight;
    nameTitleLabel.text = @"身份证号:";
    nameTitleLabel.hidden = YES;
    nameTitleLabel.tag = NAME_TITLE_LABEL_TAG;
    [self addSubview:nameTitleLabel];
    [nameTitleLabel release];
    
    UILabel *nameValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((hei-275)/2.0f+75, 32, 200, 30)];
    nameValueLabel.backgroundColor = [UIColor clearColor];
    nameValueLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    nameValueLabel.font = [UIFont systemFontOfSize:13.0f];
    nameValueLabel.textAlignment = NSTextAlignmentLeft;
    nameValueLabel.tag = NAME_VALUE_LABEL_TAG;
    nameValueLabel.hidden = YES;
    [self addSubview:nameValueLabel];
    [nameValueLabel release];

    
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((hei-275)/2.0f, 64, 70, 30)];
    addressTitleLabel.backgroundColor = [UIColor clearColor];
    addressTitleLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    addressTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    addressTitleLabel.textAlignment = NSTextAlignmentRight;
    addressTitleLabel.text = @"证件地址:";
    addressTitleLabel.hidden = YES;
    addressTitleLabel.tag = ADDRESS_TITLE_LABEL_TAG;
    [self addSubview:addressTitleLabel];
    [addressTitleLabel release];
    
    UITextView *addressValueLabel = [[UITextView alloc] initWithFrame:CGRectMake((hei-275)/2.0f+75, 64, 200, 100)];
    addressValueLabel.backgroundColor = [UIColor clearColor];
    addressValueLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    addressValueLabel.font = [UIFont systemFontOfSize:13.0f];
    addressValueLabel.textAlignment = NSTextAlignmentLeft;
    addressValueLabel.tag = ADDRESS_VALUE_LABEL_TAG;
    addressValueLabel.hidden = YES;
    [self addSubview:addressValueLabel];
    [addressValueLabel release];
    


}

- (void)reloadViewDataID:(NSString *)idString Name:(NSString *)nameString Address:(NSString *)addressString
{
    UILabel *idTitleLabel = (UILabel *)[self viewWithTag:ID_TITLE_LABEL_TAG];
    UILabel *idValueLabel = (UILabel *)[self viewWithTag:ID_VALUE_LABEL_TAG];
    
    if (idString == nil || [idString isEqualToString:@""]) {
        idTitleLabel.hidden = YES;
        idValueLabel.hidden = YES;
    }else{
        idTitleLabel.hidden = NO;
        idValueLabel.hidden = NO;
        idValueLabel.text = idString;
    }
    
    
    UILabel *nameTitleLabel = (UILabel *)[self viewWithTag:NAME_TITLE_LABEL_TAG];
    UILabel *nameValueLabel = (UILabel *)[self viewWithTag:NAME_VALUE_LABEL_TAG];
    if (nameString == nil || [nameString isEqualToString:@""]) {
        nameTitleLabel.hidden = YES;
        nameValueLabel.hidden = YES;
    }else{
        nameTitleLabel.hidden = NO;
        nameValueLabel.hidden = NO;
        nameValueLabel.text = nameString;
    }
    
    
    UILabel *addressTitleLabel = (UILabel *)[self viewWithTag:ADDRESS_TITLE_LABEL_TAG];
    UITextView *addressValueLabel = (UITextView *)[self viewWithTag:ADDRESS_VALUE_LABEL_TAG];
    if (addressString == nil || [addressString isEqualToString:@""]) {
        addressTitleLabel.hidden = YES;
        addressValueLabel.hidden = YES;
    }else{
        addressTitleLabel.hidden = NO;
        addressValueLabel.hidden = NO;
        addressValueLabel.text = addressString;
    }
}
@end
