//
//  CustomPageControl.h
//  HNUnionPro
//
//  Created by wu youjian on 5/22/12.
//  Copyright (c) 2012 Smart-Array. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    enum_color,
    enum_image
}pageType;

@protocol CustomPageControlDelegate <NSObject>
-(void)selectPage:(NSInteger)index;
@end

@interface CustomPageControl : UIView{
    NSUInteger sumPage;
    NSUInteger index;
    
    UIColor* unEnableColor;
    UIColor* enableColor;
    
    NSString* unEnableImage;
    NSString* enableImage;
    
    pageType type;
    
    NSMutableArray* btnArray;
    
    id<CustomPageControlDelegate> delegate;
    
    NSInteger prevIndex;
    NSInteger nextIndex;
}

@property (nonatomic ,retain) id<CustomPageControlDelegate> delegate;
@property (nonatomic ,retain) UIColor *unEnableColor;
@property (nonatomic ,retain) UIColor *enableColor;
@property (nonatomic ,retain) NSString* unEnableImage;
@property (nonatomic ,retain) NSString* enableImage;
@property (nonatomic ,assign) NSUInteger index;
@property (nonatomic ,assign) NSUInteger sumPage;

- (id)initWithFrame:(CGRect)frame
              sPage:(NSUInteger)sum
              iPage:(NSUInteger)idx
     unEnableColor:(UIColor*)dColor
        enableColor:(UIColor*)eColor;

- (void)setCurrentPage:(NSUInteger)idx;
- (void)reloadPageControl:(NSUInteger)sum indexPage:(NSUInteger)idx;

- (id)initWithFrame:(CGRect)frame
              sPage:(NSUInteger)sum
              iPage:(NSUInteger)idx
      unEnableImage:(NSString*)unImage
        enableImage:(NSString*)eImage;



@end
