//
//  MainViewModelsInit.m
//  WoChuangFu
//
//  Created by duwl on 12/11/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "MainViewModelsInit.h"
#import "FileHelpers.h"
#import "UrlParser.h"
#import "ModulesManager.h"

#define BASE_TAG        1000
#define SCROLL_TAG      2000
#define PAGECONTROL_TAG 2100
#define MODEL_TITLE_HEIGHT  89/2
#define MODEL_4_UP_HEIGHT   295/2
#define MODEL_4_DOWN_HEIGHT 190/2
#define MODEL_5_LEFT_WIDTH  258/2

@implementation MainViewModelsInit
{
    int currentPage;
}

-(void)dealloc
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Data:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    int type = [[dic objectForKey:@"type"] integerValue];
    self.tag = (type+1)*BASE_TAG;
    //根据不同的type值初始不同的模块
    switch (type) {
        case 0:
            [self initModelViewType_0:dic];
            break;
        case 1:
            [self initModelViewType_1:dic];
            break;
        case 2:
            [self initModelViewType_2:dic];
            break;
        case 3:
            [self initModelViewType_3:dic];
            break;
        case 4:
            [self initModelViewType_4:dic];
            break;
        case 5:
            [self initModelViewType_5:dic];
            break;
        case 6:
            [self initModelViewType_6:dic];
            break;
        case 7:
            [self initModelViewType_7:dic];
            break;
        case 8:
            [self initModelViewType_8:dic];
            break;
        default:
            break;
    }
    return self;
}

//type=0,滚动广告
-(void)initModelViewType_0:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:
                            CGRectMake(0,
                                       0,
                                       self.frame.size.width,
                                       self.frame.size.height)];
    
    scroll.delegate = self;
    scroll.pagingEnabled=YES;
    scroll.tag = SCROLL_TAG;
    scroll.showsHorizontalScrollIndicator =NO;
    for(int i=0;i<itemList.count;i++){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*self.frame.size.width, 0,
                                  self.frame.size.width, self.frame.size.height);
        button.tag = i+1+self.tag;
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        if (hasCachedImage([NSURL URLWithString:strURL])) {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                //                imageV.image = ima;
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [scroll addSubview:button];
    }
    
    scroll.contentSize = CGSizeMake(self.frame.size.width*itemList.count, self.frame.size.height);
    [self addSubview:scroll];
    
    //添加UIPageControll
    CGSize size = self.frame.size;
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = itemList.count;
    pageControl.currentPage = 0;
    pageControl.tag = PAGECONTROL_TAG;
    pageControl.center = CGPointMake(size.width / 2 ,size.height * 0.9);
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:pageControl];
    
    self.timer = [NSTimer timerWithTimeInterval:3.0f
                                         target:self
                                       selector:@selector(changePage:)
                                       userInfo:@{@"Count":@(itemList.count)}
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [pageControl release];
    [scroll release];
}

//滚动图片
- (void)changePage:(NSTimer *)timer
{
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:SCROLL_TAG];
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:PAGECONTROL_TAG];
    if (currentPage == [timer.userInfo[@"Count"]intValue])
    {
        currentPage = 0;
        [pageControl setCurrentPage:currentPage];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * currentPage, 0.0f) animated:YES];
        pageControl.currentPage = currentPage;
        currentPage ++;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:PAGECONTROL_TAG];
    [pageControl setCurrentPage:currentPage];
}

//type=1,8个菜单
-(void)initModelViewType_1:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    ModulesManager *manager =  [ModulesManager shareManager];
    manager.modulesList = itemList;
    self.backgroundColor = [UIColor whiteColor];
    float item_w = self.frame.size.width /4;
    float item_h = (self.frame.size.height-20)/2;
    
    for(int i=0;i<itemList.count;i++)
    {
        UIView* buttonV = [[UIView alloc] init];
        buttonV.frame = CGRectMake((i%4)*item_w, (i/4)*item_h, item_w, item_h);
        buttonV.tag = i+1+self.tag;
        buttonV.backgroundColor = [UIColor whiteColor];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((item_w-35)/2, (item_h-45)/2, 35, 35);
        [buttonV addSubview:button];
        
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        
        UILabel* name = [[UILabel alloc] init];
        name.frame = CGRectMake(0, (item_h-45)/2 +40, item_w, item_h - (item_h-35)/2-34);
#ifdef __IPHONE_6_0
        [name setTextAlignment:NSTextAlignmentCenter];
#else
        [name setTextAlignment:UITextAlignmentCenter];
#endif
        [name setFont:[UIFont boldSystemFontOfSize:14.0]];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = [ComponentsFactory createColorByHex:@"#666666"];
        [buttonV addSubview:name];
//        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake((item_w-35)/2, (item_h-35)/2, 35, 35);
//        [buttonV addSubview:button];
//        
//        [button addTarget:self action:@selector(clickAction:)
//         forControlEvents:UIControlEventTouchUpInside];
//        button.userInteractionEnabled = YES;
//        
//        UILabel* name = [[UILabel alloc] init];
//        name.frame = CGRectMake(0, (item_h-35)/2 + 35, item_w, item_h - (item_h-35)/2-35);
//#ifdef __IPHONE_6_0
//        [name setTextAlignment:NSTextAlignmentCenter];
//#else
//        [name setTextAlignment:UITextAlignmentCenter];
//#endif
//        [name setFont:[UIFont boldSystemFontOfSize:14.0]];
//        name.backgroundColor = [UIColor whiteColor];
//        name.textColor = [ComponentsFactory createColorByHex:@"#666666"];
//        [buttonV addSubview:name];
        
        NSString* itemName = nil;
        if (itemList.count>8 &&i ==7)
        {
           button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"gotoMore"];
            [button setImage:[UIImage imageNamed:@"btn_index_nav_more"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_index_nav_more_"] forState:UIControlStateHighlighted];
           itemName = @"更多";
           name.text = itemName;
            [name release];
            [self addSubview:buttonV];
            button.titleLabel.text = @"gotoMore";
            [buttonV release];
            break;
        }
        else
        {
            button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
            itemName = [[itemList objectAtIndex:i] objectForKey:@"name"];
            NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
            name.text = itemName;
            [name release];
            if (hasCachedImage([NSURL URLWithString:strURL]))
            {
                [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
            }
            else
            {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
                [ComponentsFactory dispatch_process_with_thread:^{
                    UIImage* ima = [self LoadImage:dic];
                    return ima;
                } result:^(UIImage *ima){
                    [button setImage:ima forState:UIControlStateNormal];
                }];
            }
            [self addSubview:buttonV];
            [buttonV release];
        }

    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 2*item_h+10,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=2,赚沃币，订单查询
-(void)initModelViewType_2:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    
    float item_w = self.frame.size.width/2;
    float item_h = self.frame.size.height-10;
    
    for(int i=0;i<itemList.count;i++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i%2)*item_w, (i/2)*item_h, item_w, item_h);
        button.tag = i+1+self.tag;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (hasCachedImage([NSURL URLWithString:strURL]))
        {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [self addSubview:button];
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,item_h,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=3,3个横排
-(void)initModelViewType_3:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    
    NSString* name = (NSString*)[dic objectForKey:@"name"];
    float title_height = 0;
    if(name != nil && name != (NSString*)[NSNull null]){
        if(![name isEqualToString:@""] && name.length >0){
            title_height = MODEL_TITLE_HEIGHT;
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, title_height)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel* title = [[UILabel alloc] init];
            title.frame = CGRectMake(5, 0, self.frame.size.width-5, title_height);
            [title setText:name];
            title.backgroundColor = [UIColor whiteColor];
            
#ifdef __IPHONE_6_0
            [title setTextAlignment:NSTextAlignmentLeft];
#else
            [title setTextAlignment:UITextAlignmentLeft];
#endif
            [view addSubview:title];
            [title release];
            [self addSubview:view];
            [view release];
        }
    }
    
    float item_w = self.frame.size.width /3;
    float item_h = self.frame.size.height-title_height-10;
    
    for(int i=0;i<itemList.count;i++){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i%3)*item_w, (i/3)*item_h+title_height, item_w, item_h);
        button.tag = i+1+self.tag;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (hasCachedImage([NSURL URLWithString:strURL])) {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [self addSubview:button];
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,item_h+title_height,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=4,4个
-(void)initModelViewType_4:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    NSString* name = (NSString*)[dic objectForKey:@"name"];
    float title_height = 0;
    if(name != nil && name != (NSString*)[NSNull null]){
        if(![name isEqualToString:@""] && name.length >0){
            title_height = MODEL_TITLE_HEIGHT;
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, title_height)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel* title = [[UILabel alloc] init];
            title.frame = CGRectMake(5, 0, self.frame.size.width-5, title_height);
            [title setText:name];
            title.backgroundColor = [UIColor whiteColor];
            
#ifdef __IPHONE_6_0
            [title setTextAlignment:NSTextAlignmentLeft];
#else
            [title setTextAlignment:UITextAlignmentLeft];
#endif
            [view addSubview:title];
            [title release];
            [self addSubview:view];
            [view release];
        }
    }
    
    //    float item_w = self.frame.size.width /3;
    //    float item_w2 = self.frame.size.width /2;
    float item_w = self.frame.size.width/2;
    float item_h= (self.frame.size.height-title_height)/2;
    
    for(int i=0;i<itemList.count;i++){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0){
            button.frame = CGRectMake(self.frame.origin.x, title_height, item_w, item_h);
        }else if(i==1){
            button.frame = CGRectMake(item_w, title_height,item_w, item_h);
        }else if(i==2){
            button.frame = CGRectMake(self.frame.origin.x, item_h+title_height, item_w, item_h);
        }else if(i==3){
            button.frame = CGRectMake(item_w, item_h+title_height, item_w, item_h);
        }
        button.tag = i+1+self.tag;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (hasCachedImage([NSURL URLWithString:strURL])) {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [self addSubview:button];
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-10,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=5,左1,右2
-(void)initModelViewType_5:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    NSString* name = (NSString*)[dic objectForKey:@"name"];
    float title_height = 0;
    if(name != nil && name != (NSString*)[NSNull null]){
        if(![name isEqualToString:@""] && name.length >0){
            title_height = MODEL_TITLE_HEIGHT;
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, title_height)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel* title = [[UILabel alloc] init];
            title.frame = CGRectMake(5, 0, self.frame.size.width-5, title_height);
            [title setText:name];
            title.backgroundColor = [UIColor whiteColor];
            
#ifdef __IPHONE_6_0
            [title setTextAlignment:NSTextAlignmentLeft];
#else
            [title setTextAlignment:UITextAlignmentLeft];
#endif
            [view addSubview:title];
            [title release];
            [self addSubview:view];
            [view release];
        }
    }
    float item_h = (self.frame.size.height-title_height-10) /2;
    float item_w = self.frame.size.width/2;
    for(int i=0;i<itemList.count;i++){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0){
            button.frame = CGRectMake(0, title_height, item_w, self.frame.size.height-title_height);
        }else if(i==1){
            button.frame = CGRectMake(item_w, title_height, item_w,item_h);
        }else if(i==2){
            button.frame = CGRectMake(item_w, item_h+title_height,item_w,item_h);
        }
        button.tag = i+1+self.tag;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (hasCachedImage([NSURL URLWithString:strURL])) {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [self addSubview:button];
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-10,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=6,一张
-(void)initModelViewType_6:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
    button.tag = 1+self.tag;
    NSString* strURL = [[itemList objectAtIndex:0] objectForKey:@"imgUrl"];
    
    button.titleLabel.text = [[itemList objectAtIndex:0] objectForKey:@"clickUrl"];
    [button addTarget:self action:@selector(clickAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    if (hasCachedImage([NSURL URLWithString:strURL])) {
        [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
    }else{
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
        [ComponentsFactory dispatch_process_with_thread:^{
            UIImage* ima = [self LoadImage:dic];
            return ima;
        } result:^(UIImage *ima){
            [button setImage:ima forState:UIControlStateNormal];
        }];
    }
    [self addSubview:button];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-10,[AppDelegate sharePhoneWidth],10)];
    bottomView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self addSubview:bottomView];
    [bottomView release];
}

//type=7,左2右1
-(void)initModelViewType_7:(NSDictionary*)dic
{
    NSArray* itemList = [dic objectForKey:@"itemList"];
    
    NSString* name = (NSString*)[dic objectForKey:@"name"];
    float title_height = 0;
    if(name != nil && name != (NSString*)[NSNull null]){
        if(![name isEqualToString:@""] && name.length >0){
            title_height = MODEL_TITLE_HEIGHT;
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, title_height)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel* title = [[UILabel alloc] init];
            title.frame = CGRectMake(5, 0, self.frame.size.width-5, title_height);
            [title setText:name];
            title.backgroundColor = [UIColor whiteColor];
            
#ifdef __IPHONE_6_0
            [title setTextAlignment:NSTextAlignmentLeft];
#else
            [title setTextAlignment:UITextAlignmentLeft];
#endif
            [view addSubview:title];
            [title release];
            [self addSubview:view];
            [view release];
        }
    }
    
    float item_h = (self.frame.size.height-title_height) /2;
    
    for(int i=0;i<itemList.count;i++){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0){
            button.frame = CGRectMake(MODEL_5_LEFT_WIDTH, title_height, self.frame.size.width-MODEL_5_LEFT_WIDTH, self.frame.size.height - title_height);
        }else if(i==1){
            button.frame = CGRectMake(0, title_height, self.frame.size.width- MODEL_5_LEFT_WIDTH, item_h);
        }else if(i==2){
            button.frame = CGRectMake(0, item_h+title_height, self.frame.size.width- MODEL_5_LEFT_WIDTH, item_h);
        }
        button.tag = i+1+self.tag;
        NSString* strURL = [[itemList objectAtIndex:i] objectForKey:@"imgUrl"];
        
        button.titleLabel.text = [[itemList objectAtIndex:i] objectForKey:@"clickUrl"];
        [button addTarget:self action:@selector(clickAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (hasCachedImage([NSURL URLWithString:strURL])) {
            [button setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])] forState:UIControlStateNormal];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",button,@"imageView",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *ima){
                [button setImage:ima forState:UIControlStateNormal];
            }];
        }
        [self addSubview:button];
    }
}

//type=8,暂时不用
-(void)initModelViewType_8:(NSDictionary*)dic
{
    
}

-(UIImage *)LoadImage:(NSDictionary*)aDic{
    //    UIView* view = [aDic objectForKey:@"imageView"];
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    //    if (image==nil) {
    //        return [UIImage imageNamed:@"loadpicture.png"];
    //    }
    //    CGSize origImageSize= [image size];
    //    CGRect newRect;
    //    newRect.origin= CGPointZero;
    //    //拉伸到多大
    //    newRect.size.width=view.frame.size.width *2;
    //    newRect.size.height=view.frame.size.height*2;
    //    //缩放倍数
    //    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    //    UIGraphicsBeginImageContext(newRect.size);
    //    CGRect projectRect;
    //    projectRect.size.width =ratio * origImageSize.width;
    //    projectRect.size.height=ratio * origImageSize.height;
    //    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    //    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    //    [image drawInRect:projectRect];
    //    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    //    //压缩比例
    //    NSData *smallData=UIImageJPEGRepresentation(small, 1);
    //    if (smallData) {
    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];
    //    }
    
    //    UIGraphicsEndImageContext();
    return image;
}

-(void)clickAction:(id)sender
{
    UIButton* clickBtn = (UIButton*)sender;
    NSString* clickUrl = clickBtn.titleLabel.text;
    if(clickUrl != nil && clickUrl.length >0)
    {
        [UrlParser gotoNewVCWithUrl:clickUrl];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"读取url失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
@end
