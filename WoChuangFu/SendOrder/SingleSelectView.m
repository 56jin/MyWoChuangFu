//
//  SingleSelectView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SingleSelectView.h"

#define SEGMENT_CLICK_BASE_TAG      100

@implementation SingleSelectView

@synthesize isOrderType;
@synthesize orderType;
@synthesize openStatus;
@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withOrderType:(BOOL)isorderType
{
    if (self = [super  initWithFrame:frame]) {
        self.isOrderType = isorderType;
        if (self.isOrderType) {
            [self layoutOrderTypeView];
        }else{
            [self layoutOpenStatusView];
        }
    }
    return self;
}

#pragma mark
#pragma mark - 布局视图
- (void)layoutOrderTypeView
{
    NSInteger cnt = 0;
    [self setOneBtnToViewWithFrame:CGRectMake(0, 0, 160/2.0f, 30)
                             Title:@"创富者订单"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    
    cnt++;
    [self setOneBtnToViewWithFrame:CGRectMake(160/2.0f+10, 0, 140/2.0f, 30)
                             Title:@"电话营销"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    
    cnt++;
    [self setOneBtnToViewWithFrame:CGRectMake(0, 25, 140/2.0f, 20)
                             Title:@"集中开户"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    UIButton *buttone = (UIButton *)[self viewWithTag:SEGMENT_CLICK_BASE_TAG];
    [self segment:buttone];
}

- (void)layoutOpenStatusView
{
    CGFloat hei = self.frame.size.height;
    NSInteger cnt = 0;
    [self setOneBtnToViewWithFrame:CGRectMake(0, 0, 87/2.0f, hei)
                             Title:@"全部"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    
    cnt++;
    [self setOneBtnToViewWithFrame:CGRectMake(87/2.0f+10, 0, 108/2.0f, hei)
                             Title:@"已开户"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    
    cnt++;
    [self setOneBtnToViewWithFrame:CGRectMake(87/2.0f+108/2.0f+20, 0, 108/2.0f, hei)
                             Title:@"未开户"
                               Tag:SEGMENT_CLICK_BASE_TAG+cnt];
    
    UIButton *buttone = (UIButton *)[self viewWithTag:SEGMENT_CLICK_BASE_TAG];
    [self segment:buttone];

}

- (void)setOneBtnToViewWithFrame:(CGRect)frame Title:(NSString *)title Tag:(NSInteger)tag
{
    CGFloat top = (frame.size.height-24/2.0f)/2.0f;
    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    oneBtn.frame = frame;
    oneBtn.backgroundColor = [UIColor clearColor];
    oneBtn.imageEdgeInsets = UIEdgeInsetsMake(top, 0, top, frame.size.width-23/2.0f);
    oneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [oneBtn setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    [oneBtn setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateHighlighted];
    [oneBtn setImage:[UIImage imageNamed:@"un-check.png"] forState:UIControlStateNormal];
    [oneBtn setTitle:title forState:UIControlStateNormal];
    [oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [oneBtn addTarget:self
               action:@selector(segment:)
     forControlEvents:UIControlEventTouchUpInside];
    oneBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    oneBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    oneBtn.tag = tag;
    [self addSubview:oneBtn];

}

#pragma mark
#pragma mark - UIAction
- (void)segment:(id)sender
{
    UIButton *clickedBtn = (UIButton *)sender;
    BOOL isSelect = clickedBtn.isSelected;
    if (isSelect) {
        
    }else{
        isSelect = !isSelect;
        [clickedBtn setSelected:YES];
        NSInteger tag = clickedBtn.tag;
        NSInteger index = tag - SEGMENT_CLICK_BASE_TAG;
        switch (index) {
            case 0:
            {
                if (isOrderType) {
                    self.orderType = chuangFuOrder;
                }else{
                    self.openStatus = All;
                }
            }
                break;
            case 1:
            {
                if (isOrderType) {
                    self.orderType = phoneSaleOrder;
                }else{
                    self.openStatus = noOpen;
                }
            }
                break;
            case 2:
            {
                if (isOrderType) {
                    self.orderType = FocusOrder;
                }else{
                    self.openStatus = isOpen;
                }
            }
                break;
            default:
                break;
        }
        for (int i=0; i<10; i++) {
            NSInteger currentTag = SEGMENT_CLICK_BASE_TAG+i;
            if (currentTag != tag) {
                UIButton *currentBtn = (UIButton *)[self viewWithTag:currentTag];
                if (currentBtn == nil) {
                    break;
                }
                [currentBtn setSelected:NO];
            }
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(singleSelectViewdidSelectValue:)]) {
            [self.delegate singleSelectViewdidSelectValue:self];
        }
        
    }
}


@end
