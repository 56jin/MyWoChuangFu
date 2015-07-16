//
//  SectionClickView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SectionClickView.h"

#define SECTION_VALUE_ORDER_LABEL_TAG     101
#define SECTION_STATUS_ORDER_LABEL_TAG    102
#define SECTION_ARROW_IMAGE_VIEW_TAG      103
#define SECTION_PHOTO_BTN_TAG             104
#define SECTION_INFO_BTN_TAG              105

#define SECTION_CONTENT_VIEW_TAG          106


@implementation SectionClickView

@synthesize delegate;
@synthesize isOpen;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame WithOpen:(BOOL)open
{
    if (self = [super initWithFrame:frame]) {
        self.isOpen = open;
       [self layoutContentView];
       
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSectionTap:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    return self;
}

- (void)layoutContentView
{
    self.backgroundColor = [ComponentsFactory createColorByHex:@"#F0F0F0"];
    
    UIView *seperView =  [[UIView alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, 1)];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [self addSubview:seperView];
    [seperView release];
    
    CGFloat hei = self.frame.size.height-5;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, hei)];
    contentView.tag = SECTION_CONTENT_VIEW_TAG;
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20/2.0f, 0, 120/2.0f, hei/2)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    titleLabel.text = @"订单号：";
    [contentView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *orderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20/2.0f+120/2.0f+1, 0, contentView.frame.size.width - 100, hei/2)];
    orderValueLabel.backgroundColor = [UIColor clearColor];
    orderValueLabel.textAlignment = NSTextAlignmentLeft;
//    orderValueLabel.adjustsFontSizeToFitWidth = YES;
    orderValueLabel.font = [UIFont systemFontOfSize:15.0f];
    orderValueLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    orderValueLabel.tag = SECTION_VALUE_ORDER_LABEL_TAG;
    [contentView addSubview:orderValueLabel];
    [orderValueLabel release];

    UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20/2.0f, hei/2, 120/2.0f, hei/2)];
    orderTypeLabel.backgroundColor = [UIColor clearColor];
    orderTypeLabel.textAlignment = NSTextAlignmentLeft;
    orderTypeLabel.font = [UIFont systemFontOfSize:15.0f];
    orderTypeLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    orderTypeLabel.tag = SECTION_STATUS_ORDER_LABEL_TAG;
    [contentView addSubview:orderTypeLabel];
    [orderTypeLabel release];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((40+hei)/2.0f, hei/2+hei/4-4.9, 26/2.0f, 26/2.0f)];
    
    [arrowView setCenter:CGPointMake(arrowView.center.x, orderTypeLabel.center.y)];
    arrowView.backgroundColor = [UIColor clearColor];
    arrowView.tag = SECTION_ARROW_IMAGE_VIEW_TAG;
    arrowView.image = [UIImage imageNamed:@"cha.png"];
    [contentView addSubview:arrowView];
    [arrowView release];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.backgroundColor = [UIColor clearColor];
    photoButton.frame = CGRectMake(80.0f+62/2.0f+20, hei/2, 60/2.0f, hei/2);
    [photoButton setCenter:CGPointMake(photoButton.center.x, orderTypeLabel.center.y)];
    [photoButton setTitle:@"开卡" forState:UIControlStateNormal];
    [photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    photoButton.tag = SECTION_PHOTO_BTN_TAG;
    photoButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [photoButton addTarget:self
                    action:@selector(photoClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:photoButton];
    
    UIButton *flowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flowBtn.backgroundColor = [UIColor clearColor];
    flowBtn.frame = CGRectMake(90.0f, hei/2, 60/2.0f, hei/2);
    [flowBtn setCenter:CGPointMake(flowBtn.center.x, orderTypeLabel.center.y)];
    [flowBtn setTitle:@"流程" forState:UIControlStateNormal];
    [flowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    flowBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    flowBtn.userInteractionEnabled = NO;
    [flowBtn addTarget:self
                    action:@selector(lookFlow:)
          forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:flowBtn];
    
    
    UIImageView *infoView = [[UIImageView alloc] initWithFrame:CGRectMake(610/2.0f, (hei-16/2.0f)/2.0f, 23/2.0f, 16/2.0f)];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.tag = SECTION_INFO_BTN_TAG;
    if (isOpen) {
        infoView.image = [self image:[UIImage imageNamed:@"down.png"] rotation:UIImageOrientationDown];
    }else{
        infoView.image = [UIImage imageNamed:@"down.png"];
    }
    [contentView addSubview:infoView];
    [infoView release];
    [self addSubview:contentView];
    [contentView release];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}



- (void)reloadSectionViewWithOrderID:(NSString *)orderID orderType:(NSString *)orderType arrowStatus:(BOOL)isShow
{
    UIView *sectionView = [self viewWithTag:SECTION_CONTENT_VIEW_TAG];
    UILabel *orderIDLabel = (UILabel *)[sectionView viewWithTag:SECTION_VALUE_ORDER_LABEL_TAG];
    UILabel *orderTypeLabel = (UILabel *)[sectionView viewWithTag:SECTION_STATUS_ORDER_LABEL_TAG];
    UIImageView *arrowView = (UIImageView *)[sectionView viewWithTag:SECTION_ARROW_IMAGE_VIEW_TAG];
    UIButton *open = (UIButton*)[sectionView viewWithTag:SECTION_PHOTO_BTN_TAG];
    if (isShow) {
        arrowView.hidden = NO;
    }else{
        arrowView.hidden = YES;
    }
    
    if ([orderType isEqualToString:@"未开户"]) {
        [open setEnabled:YES];
        [open setHidden:NO];
        
    }else if([orderType isEqualToString:@"已开户"]){
        [open setEnabled:NO];
        [open setHidden:YES];
        [open setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        
    }
    
    
    orderTypeLabel.text = orderType;
    orderIDLabel.text = orderID;
}


#pragma mark
#pragma mark - UIAction
- (void)photoClicked:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickedPhoto:)]) {
        [self.delegate didClickedPhoto:self];
    }
}

- (void)handleSectionTap:(UIGestureRecognizer *)tepRecognizer
{
    isOpen = !isOpen;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectView:isShow:)]) {
        [self.delegate didSelectView:self isShow:isOpen];
    }
}

- (void)lookFlow:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didShowCheckFlow:)]) {
        [self.delegate didShowCheckFlow:self];
    }
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
