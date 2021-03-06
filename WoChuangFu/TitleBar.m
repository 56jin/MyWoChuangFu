//
//  TitleBar.m
//  WoChuangFu
//
//  Created by duwl on 12/1/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "TitleBar.h"
#import "ResourceGetter.h"

#define LEFT_BUTTON_TAG     100
#define MINDDLE_TITLE_TAG   101
#define RIGHT_BUTTON_TAG1   102
#define RIGHT_BUTTON_TAG2   103
#define EDIT_TEXT_TAG       104
#define RIGHT_BUTTON_TAG3   105
#define RIGHT_BUTTON_TAG4   106

@implementation TitleBar

@synthesize target;

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithFram:(CGRect)frame ShowHome:(BOOL)showHome ShowSearch:(BOOL)showSearch TitlePos:(int)position
{
    self = [super initWithFrame:frame];
    
    if(self){
        isShowHome = showHome;
        isShowSearch = showSearch;
        titlePos = position;
        isSearching = NO;
        [self layoutTitleBar:frame];
    }
    
    return self;
}

- (id)initWithFramShowHome:(BOOL)showHome ShowSearch:(BOOL)showSearch TitlePos:(int)position
{
    CGRect frame = CGRectMake(0, 0, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    return [self initWithFram:frame ShowHome:showHome ShowSearch:showSearch TitlePos:position];
}

- (void)layoutTitleBar:(CGRect)frame
{
    self.backgroundColor = [ComponentsFactory createColorByHex:@"#ff7e0c"];
    //布局返回按钮
    CGRect ret_frame = CGRectMake([ResourceGetter getAddustWidthWithDefault:LEFT_RIGHT_MARGIN],
                              [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN],
                              [ResourceGetter getAddustWidthWithDefault:BTN_WIDTH],
                              [ResourceGetter getAddustHeightWithDefault:BTN_HEIGHT]);
    UIButton* retBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retBtn.frame = ret_frame;
    [retBtn setBackgroundColor:[UIColor clearColor]];
    [retBtn setImage:[ResourceGetter getAddustImageResourceWitnId:@"btn_navbar_return_n" ]
            forState:UIControlStateNormal];
    [retBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    retBtn.tag=LEFT_BUTTON_TAG;
    [self addSubview:retBtn];
    //布局title
    CGRect mid_frame = CGRectMake([ResourceGetter getAddustWidthWithDefault:LEFT_RIGHT_MARGIN]*2+BTN_WIDTH,
                                  [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN],
                                  [AppDelegate sharePhoneWidth] - [ResourceGetter getAddustWidthWithDefault:BTN_WIDTH]*2 - [ResourceGetter getAddustWidthWithDefault:LEFT_RIGHT_MARGIN]*4,
                                  TITLE_BAR_HEIGHT - [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN]*2);
    UILabel* titleLab = [[UILabel alloc] initWithFrame:mid_frame];
    titleLab.backgroundColor = [UIColor clearColor];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setFont:[UIFont systemFontOfSize:18.0]];
    if(titlePos == left_position){//title居左显示
#ifdef __IPHONE_6_0
        [titleLab setTextAlignment:NSTextAlignmentLeft];
#else
        [titleLab setTextAlignment:UITextAlignmentLeft];
#endif
    } else {//title居中显示
#ifdef __IPHONE_6_0
        [titleLab setTextAlignment:NSTextAlignmentCenter];
#else
        [titleLab setTextAlignment:UITextAlignmentCenter];
#endif
    }
    titleLab.tag = MINDDLE_TITLE_TAG;
    [self addSubview:titleLab];
    [titleLab release];
    //布局搜索图标
    float search_x = 0;
    if(isShowHome){
        search_x = [AppDelegate sharePhoneWidth] - BTN_WIDTH*2 - LEFT_RIGHT_MARGIN*2;
    } else {
        search_x = [AppDelegate sharePhoneWidth] - BTN_WIDTH - LEFT_RIGHT_MARGIN;
    }
    CGRect search_frame = CGRectMake(search_x, [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN], BTN_WIDTH, BTN_HEIGHT);
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = search_frame;
    [searchBtn setBackgroundColor:[UIColor clearColor]];
    [searchBtn setImage:[ResourceGetter getAddustImageResourceWitnId:@"btn_navbar_search_n" ]
            forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.tag=RIGHT_BUTTON_TAG1;
    if(!isShowSearch){
        [searchBtn setHidden:YES];
    }
    [self addSubview:searchBtn];
    //布局home图票
    CGRect home_frame = CGRectMake([AppDelegate sharePhoneWidth] -[ResourceGetter  getAddustWidthWithDefault:BTN_WIDTH] - [ResourceGetter getAddustWidthWithDefault:LEFT_RIGHT_MARGIN], [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN], [ResourceGetter getAddustHeightWithDefault:BTN_WIDTH], BTN_HEIGHT);
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = home_frame;
    [homeBtn setBackgroundColor:[UIColor clearColor]];
    [homeBtn setImage:[ResourceGetter getAddustImageResourceWitnId:@"btn_navbar_home_n" ]
               forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeAction:) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.tag=RIGHT_BUTTON_TAG2;
    if(!isShowHome){
        [homeBtn setHidden:YES];
    }
    [self addSubview:homeBtn];
    //布局取消搜索按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = home_frame;
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.tag = RIGHT_BUTTON_TAG3;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setHidden:YES];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    //布局搜索框
    CGRect search_edt = CGRectMake([ResourceGetter getAddustHeightWithDefault:LEFT_RIGHT_MARGIN],
                                   [ResourceGetter getAddustHeightWithDefault:TOP_MARGIN],
                                   [AppDelegate sharePhoneWidth] - [ResourceGetter getAddustWidthWithDefault:LEFT_RIGHT_MARGIN]*3 - [ResourceGetter getAddustHeightWithDefault:BTN_WIDTH],
                                   [ResourceGetter getAddustHeightWithDefault:BTN_HEIGHT]);
    _searchTxt = [[UITextField alloc] initWithFrame:search_edt];
    [_searchTxt setHidden:YES];
    _searchTxt.placeholder = @"请输入搜索关键字";
    _searchTxt.delegate = self;
    _searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchTxt setReturnKeyType:UIReturnKeySearch];
    _searchTxt.backgroundColor = [UIColor whiteColor];
    _searchTxt.tag = EDIT_TEXT_TAG;
    
//    CGRect clear_frame = CGRectMake(search_edt.size.width - CLEAR_BTN_WIDTH-LEFT_RIGHT_MARGIN, (search_edt.size.height - CLEAR_BTN_HEIGHT)/2, CLEAR_BTN_WIDTH, CLEAR_BTN_HEIGHT);
//    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    clearBtn.frame = clear_frame;
//    clearBtn.tag = RIGHT_BUTTON_TAG4;
//    [clearBtn setImage:[ResourceGetter getAddustImageResourceWitnId:@"btn_search_delete_n" ] forState:UIControlStateNormal];
//    [cancelBtn setHidden:YES];
//    [cancelBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_searchTxt addSubview:clearBtn];
    [self addSubview:_searchTxt];
    [_searchTxt release];
}

-(void)returnAction:(id)sender
{
    if(self.target != nil && [self.target respondsToSelector:@selector(backAction)]){
        [self.target performSelector:@selector(backAction) withObject:nil];
    }
}

-(void)searchAction:(id)sender
{
    if(isSearching){//隐藏搜索栏
        isSearching = NO;
        [[self viewWithTag:LEFT_RIGHT_MARGIN] setHidden:NO];
        [[self viewWithTag:MINDDLE_TITLE_TAG] setHidden:NO];
        if(isShowSearch){
        [[self viewWithTag:RIGHT_BUTTON_TAG1] setHidden:NO];
        }
        if(isShowHome){
        [[self viewWithTag:RIGHT_BUTTON_TAG2] setHidden:NO];
        }
        [[self viewWithTag:EDIT_TEXT_TAG] setHidden:YES];
        [[self viewWithTag:RIGHT_BUTTON_TAG3] setHidden:YES];
    } else {//显示搜索栏
        isSearching = YES;
        [[self viewWithTag:LEFT_RIGHT_MARGIN] setHidden:YES];
        [[self viewWithTag:MINDDLE_TITLE_TAG] setHidden:YES];
        if(isShowSearch){
        [[self viewWithTag:RIGHT_BUTTON_TAG1] setHidden:YES];
        }
        if(isShowHome){
        [[self viewWithTag:RIGHT_BUTTON_TAG2] setHidden:YES];
        }
        [[self viewWithTag:EDIT_TEXT_TAG] setHidden:NO];
        UITextField *text = (UITextField *)[self viewWithTag:EDIT_TEXT_TAG];
        [text becomeFirstResponder];
        [[self viewWithTag:RIGHT_BUTTON_TAG3] setHidden:NO];
    }
}

-(void)setSearchShow
{
    isSearching = YES;
    [[self viewWithTag:LEFT_RIGHT_MARGIN] setHidden:YES];
    [[self viewWithTag:MINDDLE_TITLE_TAG] setHidden:YES];
    if(isShowSearch){
        [[self viewWithTag:RIGHT_BUTTON_TAG1] setHidden:YES];
    }
    if(isShowHome){
        [[self viewWithTag:RIGHT_BUTTON_TAG2] setHidden:YES];
    }
    [[self viewWithTag:EDIT_TEXT_TAG] setHidden:NO];
    [[self viewWithTag:RIGHT_BUTTON_TAG3] setHidden:YES];
}

-(void)endSearching
{
    [((UITextField*)[self viewWithTag:EDIT_TEXT_TAG]) resignFirstResponder];
}

-(void)homeAction:(id)sender
{
    if(self.target != nil && [self.target respondsToSelector:@selector(homeAction)]){
        [self.target performSelector:@selector(homeAction) withObject:nil];
    }
}

-(void)cancelAction:(id)sender
{
    isSearching = NO;
    [(UITextField*)[self viewWithTag:EDIT_TEXT_TAG] resignFirstResponder];
    [[self viewWithTag:LEFT_RIGHT_MARGIN] setHidden:NO];
    [[self viewWithTag:MINDDLE_TITLE_TAG] setHidden:NO];
    if(isShowSearch){
        [[self viewWithTag:RIGHT_BUTTON_TAG1] setHidden:NO];
    }
    if(isShowHome){
        [[self viewWithTag:RIGHT_BUTTON_TAG2] setHidden:NO];
    }
    [[self viewWithTag:EDIT_TEXT_TAG] setHidden:YES];
    [[self viewWithTag:RIGHT_BUTTON_TAG3] setHidden:YES];
}

-(void)clearAction:(id)sender
{
    ((UITextField*)[self viewWithTag:EDIT_TEXT_TAG]).text = @"";
}
- (void)setLeftWithImage:(NSString *)imgName HighLightImage:(NSString *)HighLightImgName;
{
    UIButton *retBtn = (UIButton *)[self viewWithTag:LEFT_BUTTON_TAG];
    [retBtn setImage:[ResourceGetter getAddustImageResourceWitnId:imgName]
            forState:UIControlStateNormal];
    [retBtn setImage:[ResourceGetter getAddustImageResourceWitnId:HighLightImgName]
            forState:UIControlStateHighlighted];
}

- (void)setTitle:(NSString*)title
{
    [(UILabel*)[self viewWithTag:MINDDLE_TITLE_TAG] setText:title];
}

-(void)setLeftIsHiden:(BOOL)hide
{
    [(UIButton*)[self viewWithTag:LEFT_BUTTON_TAG] setHidden:hide];
}

-(void)setLeftText:(NSString *)textStr
{
   UIButton *leftBtn = (UIButton*)[self viewWithTag:LEFT_BUTTON_TAG];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitle:textStr forState:UIControlStateNormal];
    [leftBtn setImage:nil forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:nil forState:UIControlStateNormal];
    CGRect frame = leftBtn.frame;
    frame.origin.x = 250;
    frame.size.width = 70;
    leftBtn.frame = frame;
    
}

-(void)setRightImage:(NSString *)textStr {
    UIButton *rightBtn = (UIButton*)[self viewWithTag:RIGHT_BUTTON_TAG2];
    [rightBtn setImage:[ResourceGetter getAddustImageResourceWitnId:textStr ]
             forState:UIControlStateNormal];

}

-(NSString*)getSearchText
{
    return ((UITextField*)[self viewWithTag:EDIT_TEXT_TAG]).text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(self.target != nil && [self.target respondsToSelector:@selector(searchAction:)]){
        [self.target performSelector:@selector(searchAction:) withObject:((UITextField*)[self viewWithTag:EDIT_TEXT_TAG]).text];
    }
    return YES;
}
@end
