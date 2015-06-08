//
//  TitleBar.h
//  WoChuangFu
//
//  Created by duwl on 12/1/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_BAR_HEIGHT   20
#define TITLE_BAR_HEIGHT    44
#define TAB_BAR_HEIGHT      49
//左右外边距
#define LEFT_RIGHT_MARGIN   11
//上边距
#define TOP_MARGIN          12/2
//按钮高
#define BTN_HEIGHT          32
//按钮宽
#define BTN_WIDTH           32
#define SYSTEM_TITLE_HEIGHT 20

#define CLEAR_BTN_WIDTH     24
#define CLEAR_BTN_HEIGHT    24

@protocol TitleBarDelegate<NSObject>
@optional
-(void)backAction;
-(void)homeAction;
-(void)searchAction:(NSString*)key;
@end

enum title_position{
    left_position = 1,
    middle_position
};

@interface TitleBar : UIView<UITextFieldDelegate>
{
    id<TitleBarDelegate> target;
    BOOL isShowSearch;
    BOOL isShowHome;
    int titlePos;
    BOOL isSearching;
}

@property(nonatomic,retain)id<TitleBarDelegate> target;
@property(nonatomic,retain)UITextField* searchTxt;

- (id)initWithFram:(CGRect)frame ShowHome:(BOOL)showHome ShowSearch:(BOOL)showSearch TitlePos:(int)position;
//用默认的titleBar大小
- (id)initWithFramShowHome:(BOOL)showHome ShowSearch:(BOOL)showSearch TitlePos:(int)position;

- (void)setLeftWithImage:(NSString *)imgName HighLightImage:(NSString *)HighLightImgName;
- (void)setTitle:(NSString*)title;
- (void)setLeftIsHiden:(BOOL)hide;
- (void)setSearchShow;
- (void)endSearching;
- (NSString*)getSearchText;

-(void)setLeftText:(NSString *)textStr;
-(void)setRightImage:(NSString *)textStr;

@end
