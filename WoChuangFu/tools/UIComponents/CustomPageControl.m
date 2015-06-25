//
//  CustomPageControl.m
//  HNUnionPro
//
//  Created by wu youjian on 5/22/12.
//  Copyright (c) 2012 Smart-Array. All rights reserved.
//

#import "CustomPageControl.h"

#define prevBtnTag   1000
#define nextBtnTag   1001

#define pageSize 10

@implementation CustomPageControl
@synthesize unEnableColor;
@synthesize enableColor;
@synthesize unEnableImage;
@synthesize enableImage;
@synthesize delegate;
@synthesize index,sumPage;

-(void)dealloc{
    [unEnableColor release];
    [enableColor release];
    [unEnableImage release];
    [enableImage release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
              sPage:(NSUInteger)sum
              iPage:(NSUInteger)idx
      unEnableColor:(UIColor*)dColor
        enableColor:(UIColor*)eColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        sumPage = sum;
        index = idx;
        type = enum_color;
        self.unEnableColor = dColor;
        self.enableColor = eColor;
    }
    return self;
}

- (void)reloadPageControl:(NSUInteger)sum indexPage:(NSUInteger)idx
{
    for (UIView* subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    sumPage = sum;
    index = idx;
    type = enum_image;
    
    [btnArray removeAllObjects];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    NSInteger count = sumPage%pageSize == 0 ? sumPage/pageSize:sumPage/pageSize+1;
    NSInteger indexPage = index/pageSize+1;
    
    NSInteger drawcount = sumPage%pageSize == 0? pageSize:sumPage%pageSize;
    if (indexPage != count) {
        drawcount = pageSize;
    }
    
    CGFloat x = (width - 41*drawcount)/2;
    CGRect btnFrame = CGRectMake(x-60,0,60,height);
    UIButton* prevbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prevbtn.hidden = YES;
    [prevbtn setFrame:btnFrame];
    [prevbtn setTag:prevBtnTag];
    [prevbtn setTitle:@"" forState:UIControlStateNormal];
    [prevbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [prevbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevbtn];
    [btnArray addObject:prevbtn];
    
    for (int i = 0; i < drawcount; i++) {
        CGRect btnFrame = CGRectMake(x + 41*i,0,41,height);
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:btnFrame];
        [btn setTag:i + 100];
        UIImage* image = [UIImage imageNamed:unEnableImage];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btnArray addObject:btn];
    }
    
    btnFrame = CGRectMake(x+41*drawcount,0,60,height);
    UIButton* nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.hidden = YES;
    [nextbtn setFrame:btnFrame];
    [nextbtn setTag:nextBtnTag];
    [nextbtn setTitle:@"" forState:UIControlStateNormal];
    [nextbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextbtn];
    [btnArray addObject:nextbtn];
    
    NSInteger iBtn = index%pageSize;
    UIButton* indexBtn = [btnArray objectAtIndex:iBtn+1];
    UIImage* image = [UIImage imageNamed:enableImage];
    [indexBtn setImage:image forState:UIControlStateNormal];
    [indexBtn setImageEdgeInsets:UIEdgeInsetsMake(11,11,11,11)];
    [indexBtn.titleLabel setFont:[UIFont systemFontOfSize:11.5]];
    [indexBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [indexBtn setTitle:[NSString stringWithFormat:@"%d",index+1] forState:UIControlStateNormal];
    [indexBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [indexBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2,-image.size.width+1,0,-1)];
    [indexBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPage >= 2 && indexPage <= count-1) {
        // A index B
        prevbtn.hidden = NO;
        nextbtn.hidden = NO;
        
        NSInteger start = (indexPage-2)*pageSize+1;
        NSInteger end = start+pageSize-1;
        NSString* prevStr = [NSString stringWithFormat:@"%d - %d",start,end];
        [prevbtn setTitle:prevStr forState:UIControlStateNormal];
        prevIndex = start-1;
        
        start = indexPage*pageSize+1;
        end = start+pageSize-1;
        if (end > sumPage) {
            end = sumPage;
        }
        nextIndex = start-1;
        
        NSString* nextStr = [NSString stringWithFormat:@"%d - %d",start,end];
        [nextbtn setTitle:nextStr forState:UIControlStateNormal];
    }else if(indexPage == 1){
        if (count > 1) {
            // index B
            prevbtn.hidden = YES;
            nextbtn.hidden = NO;
            
            NSInteger start = indexPage*pageSize+1;
            NSInteger end = start+pageSize-1;
            if (end > sumPage) {
                end = sumPage;
            }
            
            nextIndex = start -1;
            NSString* nextStr = [NSString stringWithFormat:@"%d - %d",start,end];
            [nextbtn setTitle:nextStr forState:UIControlStateNormal];
            
        }else {
            // index
            prevbtn.hidden = YES;
            nextbtn.hidden = YES;
        }
        
    }else if(indexPage == count){
        if (count > 1) {
            // A index
            prevbtn.hidden = NO;
            nextbtn.hidden = YES;
            
            NSInteger start = (indexPage-2)*pageSize+1;
            NSInteger end = start+pageSize-1;
            NSString* prevStr = [NSString stringWithFormat:@"%d - %d",start,end];
            [prevbtn setTitle:prevStr forState:UIControlStateNormal];
            prevIndex = start-1;
        }else {
            // index
            prevbtn.hidden = YES;
            nextbtn.hidden = YES;
        }
    }
}

- (id)initWithFrame:(CGRect)frame
              sPage:(NSUInteger)sum
              iPage:(NSUInteger)idx
      unEnableImage:(NSString*)unImage
        enableImage:(NSString*)eImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.unEnableImage = unImage;
        self.enableImage = eImage;
        self.frame = frame;
        btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self reloadPageControl:sum indexPage:idx];
    }
    return self;
}

-(void)btnAction:(id)sender{
    UIButton* btn = (UIButton*)sender;
    NSInteger idx = 0;
    if (btn.tag == prevBtnTag) {
        idx = prevIndex;
    }else if(btn.tag == nextBtnTag){
        idx = nextIndex;
    }else {
        NSInteger indexPage = index/pageSize+1;
        idx = (btn.tag-100)+ (indexPage-1)*pageSize;
    }
    
     NSLog(@"btnAction:%d",idx);
    if (delegate && [delegate respondsToSelector:@selector(selectPage:)]) {
        [delegate selectPage:idx];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    if (type == enum_color) {
        // Drawing code
        CGContextRef ref= UIGraphicsGetCurrentContext();
        // CGContextBeginPath(ref);
        
        CGFloat x = (self.frame.size.width - 13*sumPage)/2 + 3.5;
        CGFloat y = (self.frame.size.height - 6)/2;
        for (int i = 0; i < sumPage; i++) {
            CGRect re = CGRectMake(x + 13*i,y, 6, 6);
            if (index == i) {
                CGContextSetFillColorWithColor(ref,enableColor.CGColor);
            }else {
                CGContextSetFillColorWithColor(ref,unEnableColor.CGColor);
            }
            
            CGContextFillEllipseInRect(ref,re);
            // CGContextFillPath(ref);
        }
    }
    
}

-(void)setCurrentPage:(NSUInteger)idx{
    
    if (type == enum_color) {
        index = idx;
        [self setNeedsDisplay];
    }else {
        UIButton* oldSelectBtn = [btnArray objectAtIndex:index+1];
        UIImage* unselImage = [UIImage imageNamed:unEnableImage];
        [oldSelectBtn setImage:unselImage forState:UIControlStateNormal];
        [oldSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
        [oldSelectBtn setTitle:nil forState:UIControlStateNormal];
        
        UIButton* newSelectBtn = [btnArray objectAtIndex:idx+1];
        UIImage* selImage = [UIImage imageNamed:enableImage];
        [newSelectBtn setImage:selImage forState:UIControlStateNormal];
        [newSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
        [newSelectBtn.titleLabel setFont:[UIFont systemFontOfSize:11.5]];
        [newSelectBtn.titleLabel setTextAlignment:UITextAlignmentCenter];
        [newSelectBtn setTitle:[NSString stringWithFormat:@"%d",idx+1] forState:UIControlStateNormal];
        [newSelectBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [newSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2,-selImage.size.width+1,0,-1)];
        
        index = idx;
    }
}

@end
