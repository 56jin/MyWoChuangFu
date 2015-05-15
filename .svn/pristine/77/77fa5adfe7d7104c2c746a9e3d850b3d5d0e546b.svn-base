//
//  PhotoScrollView.h
//  PaintSignature
//
//  Created by Wu YouJian on 10/31/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIPhotoScrollViewDelegate
//单击
- (void)clickPhoto:(UIView *)superView withSender:(id)sender;
- (void)scrollDidEnd:(UIView *)photoView withScrollView:(UIScrollView*)scrollview;
@end


@interface PhotoScrollView : UIView<UIScrollViewDelegate> {
	
	UIScrollView* photoScrollView;
	//UIView* photoView;
	id <UIPhotoScrollViewDelegate> delegate;
	BOOL firstSelected;//第一个选项是否默认选中
    UIColor *textColor;//选项文字的颜色
    float colSpan;
    UIColor *textSelectedColor;//选中选项的文字颜色
	CGRect	photoViewFrame;
	float	photoViewHeight;
	float	photoWidth;
	float	contentWidth;
    NSArray* textArr;//选项文字内容数组
	NSArray* photoNameArr;//图片名字数组
    UIFont *font;//选项文字的字体
    UIImageView *leftArrow;
    UIImageView *rightArrow;
}

@property (nonatomic, assign) id <UIPhotoScrollViewDelegate> delegate;
@property(nonatomic,retain)UIScrollView* photoScrollView;
//@property(nonatomic,retain)UIView* photoView;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,retain)UIColor *textSelectedColor;
@property(nonatomic,assign)CGRect photoViewFrame;
@property(nonatomic,assign)float photoViewHeight;
@property(nonatomic,assign)float photoWidth;
@property(nonatomic,assign)float colSpan;
@property(nonatomic,assign)BOOL firstSelected;
@property(nonatomic,retain)NSArray* photoNameArr;
@property(nonatomic,retain)NSArray *textArr;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,retain)UIImageView *leftArrow;
@property(nonatomic,retain)UIImageView *rightArrow;
-(void)fillImage;
-(void)fillLabel;
-(void)fillData;
-(void)fillView;
-(void)layoutPhotoView;
- (void)fillRemoteImage:(NSString *)defaultImage;
@end
